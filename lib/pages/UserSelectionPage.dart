import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';
import 'package:vital_signs_ui_template/elements/TryAgainTemplate.dart';
import 'package:vital_signs_ui_template/elements/VSLoadingWidget.dart';
import 'package:vital_signs_ui_template/pages/Dashboard/AbnormalVsBoard.dart';
import 'package:vital_signs_ui_template/pages/LoginPage.dart';
import 'package:vital_signs_ui_template/pages/SplashScreen.dart';

import 'doctor_pages/DoctorSplashScreen.dart';
import 'doctor_pages/HistoryPlots/StickyHeaderTest.dart';

class UserSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 120,
        turnOffBackButton: true,
        turnOffSettingsButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 80),
              child: Text(
                'Who are you?',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: FlatButton(
                    onPressed: () {
                      navigateTo(context, AbnormalVsBoard());
                    },
                    child: Image.asset(
                      "assets/images/Patient2.png",
                      scale: 1.2,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    navigateTo(context, LoginPage());
                  },
                  child: Image.asset(
                    "assets/images/Physician2.png",
                    scale: 1.2,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              //Debug options
              children: [
                FlatButton(
                  onPressed: () {
                    navigateTo(context, SplashScreen());
                  },
                  child: Text('.'),
                ),
                FlatButton(
                  onPressed: () {
                    navigateTo(context, VSLoadWidgetStlss());
                  },
                  child: Text('..'),
                ),
                FlatButton(
                  onPressed: () {
                    navigateTo(context, DoctorSplashScreen());
                  },
                  child: Text('...'),
                ),
                FlatButton(
                  onPressed: () {
                    navigateTo(context, VSplotExample());
                  },
                  child: Text('....'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  navigateTo(BuildContext context, var pageToNavigate) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => pageToNavigate),
    );
    // LoginPage()AbnormalVsBoard
  }
}
