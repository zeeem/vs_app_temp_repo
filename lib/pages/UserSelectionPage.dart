import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';
import 'package:vital_signs_ui_template/elements/TryAgainTemplate.dart';
import 'package:vital_signs_ui_template/pages/Dashboard/AbnormalVsBoard.dart';
import 'package:vital_signs_ui_template/pages/Dashboard/FilteredCharts/PatientInfo.dart';
import 'package:vital_signs_ui_template/pages/LoginPage.dart';

import 'TestApi.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container(
          //   padding: EdgeInsets.fromLTRB(20, 40, 20, 80),
          //   child: Text(
          //     'Who are you?',
          //     style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    children: [
                      FlatButton(
                        onPressed: () {
                          navigateTo(context, AbnormalVsBoard());
                        },
                        child: Image.asset(
                          "assets/images/Patient2.png",
                          scale: 1.2,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Patient',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: AppColors.textColor.withOpacity(.8)),
                      ),
                    ],
                  )),
              Column(
                children: [
                  FlatButton(
                    onPressed: () {
                      navigateTo(context, LoginPage());
                    },
                    child: Image.asset(
                      "assets/images/Physician2.png",
                      scale: 1.2,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'MD,Nurse,..',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColors.textColor.withOpacity(.8)),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //Debug options
              children: [
                FlatButton(
                  onPressed: () {
                    // navigateTo(context, SplashScreen());
                    navigateTo(context, TestAPI());
                  },
                  child: Text(
                    '.',
                    style: TextStyle(color: Colors.black26),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    //navigateTo(context, VSLoadWidgetStlss());
                    //navigateTo(context, FilteredCharts());
                    //navigateTo(context, Test());
                    navigateTo(context, PatientInfo());
                  },
                  child: Text(
                    '.',
                    style: TextStyle(color: Colors.black26),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    navigateTo(
                        context,
                        TryAgainPage(
                          displayText: 'Hi, Jon!',
                          displayText2: 'Connecting to your vital signs.',
                          isLoadingVisible: true,
                        ));
                  },
                  child: Text(
                    '.',
                    style: TextStyle(color: Colors.black26),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    navigateTo(context, VSplotExample());
                  },
                  child: Text(
                    '.',
                    style: TextStyle(color: Colors.black26),
                  ),
                ),
              ],
            ),
          ),
        ],
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
