import 'package:flutter/material.dart';
import 'package:vital_signs_app/elements/ButtonWidget.dart';
import 'package:vital_signs_app/elements/CustomAppBar.dart';

import 'configuration_page2_doctor_info.dart';

class ConfigurationPage1 extends StatefulWidget {
  @override
  _ConfigurationPage1 createState() => _ConfigurationPage1();
}

class _ConfigurationPage1 extends State<ConfigurationPage1> {
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
        child: Container(
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
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0.0),
                child: Text(
                  'Hi! I\'m Julia,\n I will assist you with the configuration of your device.',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ButtonWidget(
        buttonTitle: 'Next',
        onTapFunction: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ConfigurationPage2(),
            ),
          );
        },
      ),
    );
  }
}
