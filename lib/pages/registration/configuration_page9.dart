import 'package:vital_signs_ui_template/elements/ButtonWidget.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';

import 'configuration_page10.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/consts.dart';

class ConfigurationPage9 extends StatefulWidget {
  @override
  _ConfigurationPage9 createState() => _ConfigurationPage9();
}

class _ConfigurationPage9 extends State<ConfigurationPage9> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
                    padding: EdgeInsets.fromLTRB(50, 10, 50, 0.0),
                    child: Text(
                      'Excellent! I have successfully connected your device to your phone.',
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.fromLTRB(50, 10, 50, 0.0),
                    child: Text(
                      'The app can now monitor your vital signs',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: ButtonWidget(
          buttonTitle: 'Next',
          onTapFunction: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ConfigurationPage10(),
              ),
            );
          }),
    );
  }
}
