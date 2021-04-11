import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:omni_bliss/HomePage.dart';
import 'package:omni_bliss/bluetooth/miband.dart';
import 'package:omni_bliss/bluetooth/widgets.dart';
import 'package:omni_bliss/ui/widgets/custom_shape.dart';
import 'package:omni_bliss/ui/widgets/customappbar.dart';
import 'package:omni_bliss/ui/widgets/responsive_ui.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Profile.dart';
import '../app_usage.dart';

class FlutterBlueApp extends StatefulWidget {
  @override
  _FlutterBlueAppState createState() => _FlutterBlueAppState();
}

class _FlutterBlueAppState extends State<FlutterBlueApp> {
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Scaffold(
      body: Container(
        height: _height,
        width: _width,
        margin: EdgeInsets.only(bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Opacity(opacity: 0.88, child: CustomAppBar()),
              clipShape(),
              FlutterBlueInst(),

//                button(),
//                infoTextRow(),
              //signInTextRow(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: new Text("Home"),
            backgroundColor: Colors.deepPurple,
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), title: new Text("Profile")),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            title: Text("Usage"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text("Stress"),
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _ontappeditem,
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }

  void _ontappeditem(int value) {
    if (value == 2) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => app_usage()));
      //selectedIndex=1;
    }
    if (value == 1) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Profile()));
    }
    if (value == 0) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 8
                  : (_medium ? _height / 7 : _height / 6.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[200], Colors.deepPurple],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 12
                  : (_medium ? _height / 11 : _height / 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[200], Colors.deepPurple],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FlutterBlueInst extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) {
            return FindDevicesScreen();
          }
          return BluetoothOffScreen(state: state);
        });
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () =>
          FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<List<BluetoothDevice>>(
              stream: Stream.periodic(Duration(seconds: 2))
                  .asyncMap((_) => FlutterBlue.instance.connectedDevices),
              initialData: [],
              builder: (c, snapshot) => Column(
                children: snapshot.data
                    .where((element) => element.name.startsWith("Mi"))
                    .map((d) => ListTile(
                          title: Text(d.name),
                          subtitle: Text(d.id.toString()),
                          trailing: StreamBuilder<BluetoothDeviceState>(
                            stream: d.state,
                            initialData: BluetoothDeviceState.disconnected,
                            builder: (c, snapshot) {
                              if (snapshot.data ==
                                  BluetoothDeviceState.connected) {
                                return RaisedButton(
                                  child: Text('OPEN'),
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DeviceScreen(device: d))),
                                );
                              }
                              return Text(snapshot.data.toString());
                            },
                          ),
                        ))
                    .toList(),
              ),
            ),
            StreamBuilder<List<ScanResult>>(
              stream: FlutterBlue.instance.scanResults,
              initialData: [],
              builder: (c, snapshot) => Column(
                children: snapshot.data
                    .where((element) => element.device.name.startsWith("Mi"))
                    .map(
                      (r) => ScanResultTile(
                        result: r,
                        onTap: () => Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          r.device.connect();
                          return DeviceScreen(device: r.device);
                        })),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({Key key, this.device}) : super(key: key);

  final BluetoothDevice device;
  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  bool isAuth;
  String stateText;
  MiBand miband;
  int beatCount = 0;
  List<int> beats;

  void initState() {
    this.isAuth = false;
    this.stateText = "Trying to authorise MiBand";
    this.beats = [];
    miband = new MiBand(device: this.widget.device);
    initBand();
  }

  void initBand() async {
    bool val = await miband.init();
    print(val);
    if (val) {
      setState(() {
        isAuth = true;
        stateText = "Successfully authorised";
      });
    } else {
      setState(() {
        stateText = "Authorisation failed";
      });
    }
  }

  void callBackFn(int bt) {
    beatCount++;
    beats.add(bt);
    if (beatCount <= 50) {
      setState(() {
        stateText = "Beats :" + beatCount.toString();
      });
    }
    if (beatCount == 50) {
      miband.stopHrm();
      setState(() {
        stateText = "Beat collection completed...sending to API";
      });
      postMeasure();
    }
  }

  void postMeasure() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String hrStr = "";
    for (int i = 0; i < 50; i++) {
      if (i < 49)
        hrStr += this.beats[i].toString() + " ";
      else
        hrStr += this.beats[i].toString();
    }
    print(hrStr);
    final response = await http.post(
      Uri.https('omnibliss-backend2.herokuapp.com', '/api/measure/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ' + prefs.getString('token'),
      },
      body: jsonEncode(<String, String>{'hr': hrStr}),
    );
    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      String status = res['status'] as String;
      print(response.body);
      print(status);
      setState(() {
        stateText = "You have " + status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    BluetoothDevice device = this.widget.device;

    return Scaffold(
      appBar: AppBar(
        title: Text("Measure stress: " + device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => device.disconnect();
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => device.connect();
                  text = 'CONNECT';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return FlatButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .button
                        ?.copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
                stream: device.state,
                initialData: BluetoothDeviceState.connecting,
                builder: (c, snapshot) => ListTile(
                      leading: (snapshot.data == BluetoothDeviceState.connected)
                          ? Icon(Icons.bluetooth_connected)
                          : Icon(Icons.bluetooth_disabled),
                      title: Text(
                          'Device is ${snapshot.data.toString().split('.')[1]}.'),
                      subtitle: Text('${device.id}'),
                    )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(this.stateText),
                TextButton(
                  child: Text("Measure Start"),
                  onPressed: () {
                    setState(() {
                      stateText = "Started measuring heart rate";
                    });
                    if (isAuth) {
                      miband.startHrm(callback: callBackFn);
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
