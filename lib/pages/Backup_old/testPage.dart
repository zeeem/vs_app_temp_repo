//import 'package:vital_signs_ui_template/elements/ButtonWidget.dart';
//import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';
//
//import 'configuration_page5.dart';
//import 'package:flutter/material.dart';
//import 'package:vital_signs_ui_template/core/consts.dart';
//
//class ConfigurationPage4 extends StatefulWidget {
//  @override
//  _ConfigurationPage4 createState() => _ConfigurationPage4();
//}
//
//class _ConfigurationPage4 extends State<ConfigurationPage4> {
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//  }
//
////  getDirLocation() async {
////
////    File file = await File('$path/counter.txt');
////    file.writeAsString('this is test');
////  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      resizeToAvoidBottomPadding: false,
//      appBar: CustomAppBar(
//        height: 130, //no use of this fixed height
//      ),
//      body: SingleChildScrollView(
//        child: Column(
//          children: <Widget>[
//            Container(
//              child: Column(
//                children: <Widget>[
//                  Container(
//                    padding: EdgeInsets.fromLTRB(50, 0, 50, 0.0),
//                    child: Align(
//                      child: Image.asset(
//                        "assets/images/vs_avatar_01.png",
//                        scale: 0.75,
//                      ),
//                    ),
//                  ),
//                  Container(
//                    padding: EdgeInsets.fromLTRB(50, 0, 50, 0.0),
//                    child: Text(
//                      'In the case of an emergency, we will add up to three persons that the app can quickly call in case you need help.',
//                      style: TextStyle(
//                          fontSize: 23.0, fontWeight: FontWeight.bold),
//                      textAlign: TextAlign.center,
//                    ),
//                  )
//                ],
//              ),
//            ),
//            Container(
//                padding: EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
//                child: Column(
//                  children: <Widget>[
//                    TextField(
//                      decoration: InputDecoration(
//                          labelText: 'Name of emergency contact #1',
//                          labelStyle: TextStyle(
//                              fontFamily: 'OpenSans',
//                              fontWeight: FontWeight.bold,
//                              color: Colors.grey),
//                          focusedBorder: UnderlineInputBorder(
//                              borderSide: BorderSide(color: Colors.lightBlue))),
//                    ),
//                    SizedBox(height: 30.0),
//                    TextField(
//                      decoration: InputDecoration(
//                          labelText: 'Phone number',
//                          labelStyle: TextStyle(
//                              fontFamily: 'OpenSans',
//                              fontWeight: FontWeight.bold,
//                              color: Colors.grey),
//                          focusedBorder: UnderlineInputBorder(
//                              borderSide: BorderSide(color: Colors.lightBlue))),
//                    ),
//                    SizedBox(height: 30.0),
//                  ],
//                )),
//            SizedBox(height: 30),
//          ],
//        ),
//      ),
//      bottomNavigationBar: ButtonWidget(
//        buttonTitle: 'Next',
//        onTapFunction: () {
//          Navigator.of(context).push(
//            MaterialPageRoute(
//              builder: (_) => ConfigurationPage5(),
//            ),
//          );
//        },
//      ),
//    );
//  }
//}
