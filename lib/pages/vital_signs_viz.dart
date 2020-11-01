import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:vital_signs_ui_template/Processing/BTconnection.dart';
import 'package:vital_signs_ui_template/Processing/widgets.dart';
import 'package:vital_signs_ui_template/core/configVS.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:vital_signs_ui_template/elements/ButtonWidget.dart';
import 'package:vital_signs_ui_template/elements/info_card.dart';
import 'package:flutter_blue/flutter_blue.dart';

//import 'package:vital_signs_ui_template/pages/home_page.dart';

String final_HR_to_show = '84';
String final_RR_to_show = '15';
String final_SPO2_to_show = '99';
String final_temp_to_show = '37.5';

class VitalSignsViz extends StatefulWidget {
  @override
  _VitalSignsVizState createState() => _VitalSignsVizState();
}

class _VitalSignsVizState extends State<VitalSignsViz> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Journal',
      style: optionStyle,
    ),
    Text(
      'Index 2: Profile',
      style: optionStyle,
    ),
  ];

  initState() {
    super.initState();
    if (!localConfigVS.isDeviceConnected) {
      Future.delayed(Duration.zero, () => deviceConnectionRequest(context));
    }
//    updateVsValues();
  }

//  updateVsValues() {
//    setState(() {
//      final_HR_to_show = VS_Values.final_static_HR;
//      final_RR_to_show = VS_Values.final_static_RR;
//      final_SPO2_to_show = VS_Values.final_static_SPO2;
//      final_temp_to_show = VS_Values.final_static_temp;
//    });
//  }

  deviceConnectionRequest(BuildContext context) async {
    return Alert(
        context: context,
        title: 'VS device is not connected to your phone.',
        buttons: [
          DialogButton(
              child: Text(
                'CONNECT NOW',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              color: AppColors.buttonColor,
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FlutterBlueApp()),
                );
              })
        ]).show();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 130,
                      decoration: BoxDecoration(
                        color: AppColors.deccolor3,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.deccolor2,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                    ),
                    Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: AppColors.deccolor1,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(250),
                          bottomRight: Radius.circular(250),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 100, 50, 0.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Welcome, Daniel',
                            style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(.7)),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 50, 10, 0.0),
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: AppColors.textColor,
                          size: 40,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FlutterBlueApp()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 0, top: 20, right: 0, bottom: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
//                      color: AppColors.mainColor.withOpacity(0.03),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                        child: Center(
                          child: Center(
                            child: Wrap(
                              runSpacing: 20,
                              spacing: 20,
                              children: <Widget>[
                                InfoCard(
                                  title: "Heart Rate",
                                  iconPath: 'assets/icons/hr_icon.png',
                                  valueUnit: 'bpm',
                                  valueToShow: '$final_HR_to_show',
                                  press: () {},
                                ),
                                InfoCard(
                                  title: "Temperature",
                                  iconPath: 'assets/icons/temp_icon.png',
                                  valueUnit: '°C',
                                  valueToShow: '$final_temp_to_show',
                                  press: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 0, top: 20, right: 0, bottom: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.deccolor3.withOpacity(.1),
                          borderRadius: BorderRadius.circular(25),
//                      boxShadow: [
//                        BoxShadow(
//                          color: Colors.grey.withOpacity(0.05),
//                          spreadRadius: 1,
//                          blurRadius: 1,
//                          offset: Offset(1, 2), // changes position of shadow
//                        ),
//                      ],
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
//                          height: 40,
                              width: 60,
                              child: Image.asset('assets/icons/spo2_icon.png'),
                            ),
                            SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Oxygen Saturation',
                                    style: TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 17),
                                  ),
//                              SizedBox(height: 4),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '$final_SPO2_to_show',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 35,
                                        ),
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        '%',
                                        style: TextStyle(fontSize: 20),
//                                    textAlign: TextAlign.end,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 0, top: 20, right: 0, bottom: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.deccolor3.withOpacity(.1),
                          borderRadius: BorderRadius.circular(25),
//                      boxShadow: [
//                        BoxShadow(
//                          color: Colors.grey.withOpacity(0.05),
//                          spreadRadius: 1,
//                          blurRadius: 1,
//                          offset: Offset(1, 2), // changes position of shadow
//                        ),
//                      ],
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
//                          height: 40,
                              width: 60,
                              child: Image.asset('assets/icons/rr_icon.png'),
                            ),
                            SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Respiration Rate',
                                    style: TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 17),
                                  ),
//                              SizedBox(height: 4),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '$final_RR_to_show',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 35,
                                        ),
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        'rpm',
                                        style: TextStyle(fontSize: 20),
//                                    textAlign: TextAlign.end,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: ButtonWidget(
            buttonTitle: 'I NEED HELP',
            secondaryButtonStyle: 2,
            onTapFunction: () {}));
  }
}

//bottomNavigationBar: BottomNavigationBar(
//items: const <BottomNavigationBarItem>[
//BottomNavigationBarItem(
//icon: Icon(Icons.home),
//title: Text('Home'),
//),
//BottomNavigationBarItem(
//icon: Icon(Icons.assessment),
//title: Text('Journal'),
//),
//BottomNavigationBarItem(
//icon: Icon(Icons.account_circle),
//title: Text('Profile'),
//),
//],
//currentIndex: _selectedIndex,
//selectedItemColor: Colors.amber[800],
//onTap: _onItemTapped,
//),
