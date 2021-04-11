import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:omni_bliss/HomePage.dart';
import 'package:omni_bliss/app_usage.dart';
import 'package:omni_bliss/bluetooth/blue.dart';
import 'package:omni_bliss/ui/widgets/custom_shape.dart';
import 'package:omni_bliss/ui/widgets/customappbar.dart';
import 'package:omni_bliss/ui/widgets/responsive_ui.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_select/smart_select.dart' show S2Choice, SmartSelect;
import 'package:smart_select/smart_select.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class UserProfile {
  int age;
  int annual_salary;
  int hobbies;
  String gender;
  int occupation;

  UserProfile(
      this.age, this.annual_salary, this.gender, this.hobbies, this.occupation);

  factory UserProfile.fromJson(dynamic json) {
    return UserProfile(
        json['age'] as int,
        json['annual_salary'] as int,
        json['gender'] as String,
        json['hobbies'] as int,
        json['occupation'] as int);
  }

  @override
  String toString() {
    return '{ ${this.age} ,${this.annual_salary},${this.gender},${this.hobbies},${this.occupation}}';
  }
}

class _ProfileState extends State<Profile> {
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  String _genderValue = '', _occupationValue = '';
  List<String> Interests_ = [];
  int selectedIndex = 1;
  double _ageValue = 20;
  double _salaryValue = 100000;
  bool isLoading;
  void initState() {
    super.initState();
    isLoading = true;
  }

  List<S2Choice<String>> Occupations_ = [
    S2Choice<String>(
        value: '0', title: 'Agriculture, Food and Natural Resources'),
    S2Choice<String>(value: '1', title: "Architecture and Construction"),
    S2Choice<String>(
        value: '2', title: 'Business Management and Administration'),
    S2Choice<String>(
        value: '3', title: 'Arts, Audio/Video Technology and Communications'),
    S2Choice<String>(value: '4', title: 'Education and Training'),
    S2Choice<String>(value: '5', title: 'Finance'),
    S2Choice<String>(value: '6', title: 'Government and Public Administration'),
    S2Choice<String>(value: '7', title: 'Health Science'),
    S2Choice<String>(value: '8', title: 'Hospitality and Tourism'),
    S2Choice<String>(value: '9', title: 'Human Services'),
    S2Choice<String>(value: '10', title: 'Information Technology'),
    S2Choice<String>(
        value: '11', title: 'Law, Public Safety, Corrections and Security'),
    S2Choice<String>(value: '12', title: 'Manufacturing'),
    S2Choice<String>(value: '13', title: 'Marketing, Sales and Service'),
    S2Choice<String>(
        value: '14',
        title: 'Science, Technology, Engineering, and Mathematics'),
    S2Choice<String>(
        value: '15', title: 'Transportation, Distribution and Logistics'),
  ];
  List<S2Choice<String>> Gender = [
    S2Choice<String>(value: '0', title: 'Male'),
    S2Choice<String>(value: '1', title: "Female"),
    S2Choice<String>(value: '2', title: 'Others')
  ];

  List<S2Choice<String>> Interest = [
    S2Choice<String>(value: '0', title: 'Music, Songs and Dance'),
    S2Choice<String>(
        value: '1', title: "Watching TV, Movies, Netflix, Web Series"),
    S2Choice<String>(value: '2', title: 'Outdoor Sports, Adventurous Sports'),
    S2Choice<String>(value: '3', title: 'Indoor Board Games, Video Games'),
    S2Choice<String>(value: '4', title: 'Cooking, Baking'),
    S2Choice<String>(value: '5', title: 'Gardening, Planting'),
    S2Choice<String>(value: '6', title: 'Yoga, Meditation, Exercise'),
    S2Choice<String>(value: '7', title: 'Reading Books, Novels, Poetry'),
    S2Choice<String>(
        value: '8', title: 'Writing Poetry, Books, Novels, Stories'),
  ];

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    if (this.isLoading == true) {
      loadDataFromServer().then((userProfile) {
        setState(() {
          this.isLoading = false;
          print("hurray");
          if (userProfile.gender.toString().isEmpty == false) {
            this._genderValue = userProfile.gender.toString();
          }
          if (userProfile.occupation.toString().isEmpty == false) {
            this._occupationValue = userProfile.occupation.toString();
          }
          if (userProfile.age.toString().isEmpty == false) {
            this._ageValue = userProfile.age.roundToDouble();
          }
          if (userProfile.annual_salary.toString().isEmpty == false) {
            this._salaryValue = userProfile.annual_salary.roundToDouble();
          }
          if (userProfile.hobbies.toString() != null &&
              userProfile.hobbies != null) {
            int num = userProfile.hobbies;
            int count = 0;
            List<String> interestsIndex = [];
            while (num > 0) {
              if (num % 2 == 1) {
                interestsIndex.add(count.toString());
              }
              double num1 = num / 2;
              num = num1.floor();
              count++;
            }
            this.Interests_ = interestsIndex;
          }
        });
      });
    }

    return Material(
      child: Scaffold(
          body: Container(
            height: _height,
            width: _width,
            margin: EdgeInsets.only(bottom: 5),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Opacity(opacity: 0.88, child: CustomAppBar()),
                  clipShape(),
                  form(context),
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
          )),
    );
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

  Widget form(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 20.0),
      child: this.isLoading
          ? CircularProgressIndicator()
          : Form(
              child: Column(
                children: <Widget>[
                  genderFormField(context),
                  SizedBox(
                    height: _height / 60.0,
                    width: _width / 1.6,
                  ),
//            ageFormField(),
//            SizedBox(height: _height/ 60.0),
                  occupationFormField(context),
                  SizedBox(height: _height / 60.0),
                  interestsFormField(),
                  SizedBox(height: _height / 60.0),
                  ageFormField(),
                  SizedBox(height: _height / 60.0),
                  salaryFormField(),
                ],
              ),
            ),
    );
  }

  Widget genderFormField(BuildContext context) {
    return Column(children: <Widget>[
      const SizedBox(height: 7),
      SmartSelect<String>.single(
        title: 'Gender',
        choiceItems: Gender,
        value: _genderValue,
        onChange: (selected) => setState(() => _genderValue = selected.value),
        modalType: S2ModalType.bottomSheet,
        choiceType: S2ChoiceType.chips,
        choiceStyle: S2ChoiceStyle(
          color: Colors.blueGrey,
        ),
        tileBuilder: (context, state) => S2Tile.fromState(
          state,
          isTwoLine: true,
          leading: Container(
            width: 40,
            alignment: Alignment.center,
            child: const Icon(Icons.person_outline),
          ),
        ),
      ),
    ]);
  }

  Widget occupationFormField(BuildContext context) {
    return Column(children: <Widget>[
      const SizedBox(height: 7),
      SmartSelect<String>.single(
        title: 'Occupations',
        choiceItems: Occupations_,
        value: _occupationValue,
        onChange: (selected) =>
            setState(() => _occupationValue = selected.value),
        modalType: S2ModalType.fullPage,
        choiceType: S2ChoiceType.chips,
        choiceStyle: S2ChoiceStyle(
          color: Colors.blueGrey,
        ),
        tileBuilder: (context, state) => S2Tile.fromState(
          state,
          isTwoLine: true,
          leading: Container(
            width: 40,
            alignment: Alignment.center,
            child: const Icon(Icons.card_travel),
          ),
        ),
      ),
    ]);
  }

  Widget interestsFormField() {
    return Column(children: <Widget>[
      const SizedBox(height: 7),
      SmartSelect<String>.multiple(
        title: 'Interests',
        choiceItems: Interest,
        value: Interests_,
        onChange: (selected) => setState(() {
//          print(selected.value);
          return Interests_ = selected.value;
        }),
        modalType: S2ModalType.fullPage,
        choiceType: S2ChoiceType.chips,
        choiceStyle: S2ChoiceStyle(
          color: Colors.blueGrey,
        ),
        tileBuilder: (context, state) => S2Tile.fromState(
          state,
          isTwoLine: true,
          leading: Container(
            width: 40,
            alignment: Alignment.center,
            child: const Icon(Icons.favorite),
          ),
        ),
      ),
    ]);
  }

  void _ontappeditem(int value) {
    if (value == 0) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePage()));
      //selectedIndex=1;
    }
    if (value == 2) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => app_usage()));
    }
    if (value == 3) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => FlutterBlueApp()));
    }
  }

  Widget ageFormField() {
    return Column(
      children: <Widget>[
        const SizedBox(height: 7),
        Text(
          "Your Age is",
        ),
        Slider(
          value: _ageValue,
          min: 1,
          max: 100,
          divisions: 100,
          label: _ageValue.round().abs().toString(),
          onChanged: (double value) {
            setState(() {
              _ageValue = value;
            });
          },
        )
      ],
    );
  }

  Widget salaryFormField() {
    return Column(
      children: <Widget>[
        const SizedBox(height: 7),
        Text(
          "Your Salary is",
        ),
        Slider(
          value: _salaryValue,
          min: 1,
          max: 10000000,
          divisions: 100000,
          label: _salaryValue.round().abs().toString(),
          onChanged: (double value) {
            setState(() {
              _salaryValue = value;
            });
          },
        )
      ],
    );
  }

  Future<UserProfile> loadDataFromServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.https('omnibliss-backend2.herokuapp.com',
          '/api/accounts/' + prefs.getString('username') + '/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ' + prefs.getString('token'),
      },
    );
    UserProfile userProfile = UserProfile.fromJson(jsonDecode(response.body));
    print(userProfile.toString() + '&&');
    return userProfile;
  }

//  salaryFormField() {}
}
