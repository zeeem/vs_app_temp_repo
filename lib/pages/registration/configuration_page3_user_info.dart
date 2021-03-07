import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/configVS.dart';
import 'package:vital_signs_ui_template/elements/ButtonWidget.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';

import 'configuration_page4_contact1.dart';

class ConfigurationPage3 extends StatefulWidget {
  @override
  _ConfigurationPage3 createState() => _ConfigurationPage3();
}

class _ConfigurationPage3 extends State<ConfigurationPage3> {
  final userNameController = TextEditingController();
  final userPhoneController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
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
                      'To correctly identify you and make this more human, can you please fill your name and phone number here.',
                      style: TextStyle(
                          fontSize: 21.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: userNameController,
                    decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlue))),
                  ),
                  SizedBox(height: 30.0),
                  TextField(
                    controller: userPhoneController,
                    decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlue))),
                  ),
                  SizedBox(height: 30.0),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ButtonWidget(
        buttonTitle: 'Next',
        onTapFunction: () {
          //saving PROFILE data in the static vars
          profileData.USER_FULL_NAME = userNameController.text;
          profileData.USER_PHONE = userPhoneController.text;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ConfigurationPage4(),
            ),
          );
        },
      ),
    );
  }
}
