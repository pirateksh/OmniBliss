import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:convert/convert.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/block/modes/ecb.dart';

String UUID_BASE(x) {
  return '0000$x-0000-3512-2118-0009af100700';
}

const UUID_SERVICE_GENERIC_ACCESS = '1800';
const UUID_SERVICE_GENERIC_ATTRIBUTE = '1801';
const UUID_SERVICE_DEVICE_INFORMATION = '180A';
const UUID_SERVICE_FIRMWARE = '00001530-0000-3512-2118-0009af100700';
const UUID_SERVICE_ALERT_NOTIFICATION = '1811';
const UUID_SERVICE_IMMEDIATE_ALERT = '1802';
const UUID_SERVICE_HEART_RATE = '180D';
const UUID_SERVICE_MIBAND_1 = 'FEE0';
const UUID_SERVICE_MIBAND_2 = 'FEE1';

const UUID_DESCRIPTOR_NOTIFICATION = '00002902-0000-1000-8000-00805f9b34fb';

class MiBand {
  MiBand({this.device}) {
    this.key = hex.decode('352787a02da33893486f7a9856288db9');
    state = 0;
  }

  final BluetoothDevice device;
  List<int> key;
  BluetoothCharacteristic auth, steps, hrm_ctrl, hrm_data, time;
  BluetoothDescriptor desc_auth, desc_hrm;
  int state;
  Timer hrm_timer;
  Future<bool> init() async {
    await this.device.connect();
    List<BluetoothService> services = await this.device.discoverServices();
    services.forEach((service) {
      String uuid = service.uuid.toString().toUpperCase().substring(4, 8);
      List<BluetoothCharacteristic> blueChar = service.characteristics;

      switch (uuid) {
        case UUID_SERVICE_MIBAND_2:
          blueChar.forEach((f) {
            if (f.uuid.toString().compareTo(UUID_BASE('0009')) == 0) {
              this.auth = f;
              List<BluetoothDescriptor> blueDesc = f.descriptors;
              blueDesc.forEach((d) {
                if (d.uuid.toString().compareTo(UUID_DESCRIPTOR_NOTIFICATION) ==
                    0) {
                  this.desc_auth = d;
                }
              });
            }
          });
          break;
        case UUID_SERVICE_MIBAND_1:
          blueChar.forEach((f) {
            if (f.uuid.toString().compareTo(UUID_BASE('0007')) == 0) {
              this.steps = f;
            } else if (f.uuid
                    .toString()
                    .compareTo("00002a2b-0000-1000-8000-00805f9b34fb") ==
                0) {
              this.time = f;
            }
          });
          break;
        case UUID_SERVICE_HEART_RATE:
          blueChar.forEach((f) {
            if (f.uuid
                    .toString()
                    .toUpperCase()
                    .substring(4, 8)
                    .compareTo('2A39') ==
                0) {
              this.hrm_ctrl = f;
            }
            if (f.uuid
                    .toString()
                    .toUpperCase()
                    .substring(4, 8)
                    .compareTo('2A37') ==
                0) {
              this.hrm_data = f;
              List<BluetoothDescriptor> blueDesc = f.descriptors;
              blueDesc.forEach((d) {
                if (d.uuid.toString().compareTo(UUID_DESCRIPTOR_NOTIFICATION) ==
                    0) {
                  this.desc_hrm = d;
                }
              });
            }
          });
          break;
      }
    });
    await this.auth.setNotifyValue(true);
    this.auth.value.listen((data) {
      print(data);
      if (data.length < 3) return;
      String cmd = hex.encode(data.sublist(0, 3));
      print(cmd);
      if (cmd.compareTo("100101") == 0)
        this.authReqRandKey();
      else if (cmd.compareTo("100104") == 0) {
        print("Key send failed");
        this.state = -1;
      } else if (cmd.compareTo("100201") == 0) {
        BlockCipher cipher = ECBBlockCipher(AESFastEngine());
        cipher.init(
          true,
          KeyParameter(key),
        );
        List<int> cipherText = cipher.process(data.sublist(3));
        this.authSendEncText(cipherText);
      } else if (cmd.compareTo('100301') == 0) {
        print('Authenticated');
        this.state = 1;
      } else if (cmd == '100104') {
        // Set New Key FAIL
        print('Key sending failed');
        this.state = -1;
      } else if (cmd == '100204') {
        // Req Random Number FAIL
        print('Key sending failed');
        this.state = -1;
      } else if (cmd == '100304') {
        print('Encryption Key Auth Fail, sending new key...');
        this.authSendNewKey();
      } else {
        print('Unknown error');
        this.state = -1;
      }
    });

    return await this.authenticate();
  }

  Future<bool> authenticate() async {
    print("Enabling Auth service notifications");
    await this.desc_auth.write([0x01, 0x00]);
    await this.authReqRandKey();
    // await this.authReqRandKey();
    // while (this.state == 0);

    await Future.delayed(const Duration(seconds: 10), () {
      if (this.state == 1) {
        print("Auth success!!");
        return true;
        // print("Disabling Auth service notifications");
        // this.desc_auth.write([0x00, 0x00]);

        // this.startHrm();
        // Future.delayed(const Duration(seconds: 10), () {
        //   this.stopHrm();
        // });
      } else {
        print("Some error occured");
        return false;
      }
    });
    return true;
  }

  Future<void> authReqRandKey() async {
    print("Requesting random number...");
    await this.auth.write([0x02, 0x00], withoutResponse: true);
  }

  Future<void> authSendEncText(data) async {
    print("Sending encrypted random number...");
    List<int> buf = [0x03, 0x00] + data;
    print(buf.toString());
    await this.auth.write(buf, withoutResponse: true);
  }

  Future<void> authSendNewKey() async {
    print("Sending new key...");
    await this.auth.write([0x01, 0x08] + this.key, withoutResponse: true);
  }

  void startHrm({Function(int) callback}) async {
    await this.hrm_data.setNotifyValue(true);
    this.hrm_data.value.listen((data) {
      if (data.length < 1) return;
      var bytes = Uint8List.fromList(data).buffer;
      int rate = new ByteData.view(bytes).getInt16(0);
      callback(rate);
      print("Heart rate:" + rate.toString());
    });
    await this.hrm_ctrl.write([0x15, 0x02, 0x00]);
    print("H write 1");
    await this.hrm_ctrl.write([0x15, 0x01, 0x00]);
    print("H write 2");
    await this.desc_hrm.write([0x01, 0x00]);
    await this.hrm_ctrl.write([0x15, 0x01, 0x01]);
    print("H write 3");
    // List<int> d = await this.time.read();
    // print(d.toString());

    this.hrm_timer = new Timer.periodic(const Duration(seconds: 10), (timer) {
      print("Pinging HRM");
      this.hrm_ctrl.write([0x16]);
    });
  }

  void stopHrm() async {
    this.hrm_timer.cancel();
    this.hrm_timer = null;
    await this.hrm_ctrl.write([0x15, 0x01, 0x00], withoutResponse: true);
    print("H end");
  }
}
