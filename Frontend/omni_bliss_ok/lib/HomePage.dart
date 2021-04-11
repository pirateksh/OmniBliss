import 'package:flutter/material.dart';
import 'package:omni_bliss/Profile.dart';
import 'package:omni_bliss/app_usage.dart';
import 'package:omni_bliss/ui/widgets/custom_shape.dart';
import 'package:omni_bliss/ui/widgets/customappbar.dart';
import 'package:omni_bliss/ui/widgets/responsive_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bluetooth/blue.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              SizedBox(
                height: _height / 35,
              ),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.call),
        elevation: 5.0,
        onPressed: makeCall,
        backgroundColor: Colors.redAccent,
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
    if (value == 3) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => FlutterBlueApp()));
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

  void makeCall() {
    makeCall1();
  }

  Future<void> makeCall1() async {
    const url = "tel:+918979264845";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
