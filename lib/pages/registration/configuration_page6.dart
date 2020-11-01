import 'package:vital_signs_ui_template/elements/ButtonWidget.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';

import 'configuration_page7.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/consts.dart';

//import 'dart:io';
//import 'package:path_provider/path_provider.dart';
//import 'package:vital_signs_ui_template/pages/home_page.dart';

class ConfigurationPage6 extends StatefulWidget {
  @override
  _ConfigurationPage6 createState() => _ConfigurationPage6();
}

class _ConfigurationPage6 extends State<ConfigurationPage6> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

//  getDirLocation() async {
//
//    File file = await File('$path/counter.txt');
//    file.writeAsString('this is test');
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        height: 130, //no use of this fixed height
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(50, 0, 50, 0.0),
                    child: Align(
                      child: Image.asset(
                        "assets/images/vs_avatar_01.png",
                        scale: 0.90,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(50, 0, 50, 0.0),
                    child: Text(
                      'Here is your third and last contact in case of emergency.',
                      style: TextStyle(
                          fontSize: 21.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                          labelText: 'Name of emergency contact #3',
                          labelStyle: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlue))),
                    ),
                    SizedBox(height: 30.0),
                    TextField(
                      decoration: InputDecoration(
                          labelText: 'Phone number',
                          labelStyle: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlue))),
                    ),
                    SizedBox(height: 30.0),
                  ],
                )),
            SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: ButtonWidget(
          buttonTitle: 'Next',
          onTapFunction: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ConfigurationPage7(),
              ),
            );
          }),
    );
  }
}
