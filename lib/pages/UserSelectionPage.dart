import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/Processing/NetworkGateway/networkManager.dart';
import 'package:vital_signs_ui_template/core/configVS.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';
import 'package:vital_signs_ui_template/elements/TryAgainTemplate.dart';
import 'package:vital_signs_ui_template/pages/Dashboard/AbnormalVsBoard.dart';
import 'package:vital_signs_ui_template/pages/LoginPage.dart';

import 'TestApi.dart';
import 'doctor_pages/AutoComplete/AutoCompleteDrugs.dart';
import 'doctor_pages/HistoryPlots/StickyHeaderTest.dart';
import 'doctor_pages/PatientInfo/PatientInfoScreen.dart';

class UserSelection extends StatefulWidget {
  @override
  _UserSelectionState createState() => _UserSelectionState();
}

class _UserSelectionState extends State<UserSelection> {
  String username = 'testuservs';

  String password = 'Apple';

  @override
  void initState() {
    inti_logout();
    super.initState();
  }

  inti_logout() async {
    await logoutAccount();
  }

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
                        onPressed: () async {
                          await logout_and_login();

                          await fetchVSData(
                              new DateTime(2021, 3, 5, 15, 0, 0).toUtc(),
                              new DateTime(2021, 3, 5, 16, 0, 0).toUtc(),
                              'min');

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
                    navigateTo(context, PatientInfoScreen());
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
                        )
                        // AutoCompleteDrugs()
                        );
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

  logout_and_login() async {
    int statusCode = await logIntoAccount(username, password);
    print(statusCode);
  }

  Future<String> fetchVSData(
      DateTime timeFrom, DateTime timeTo, String type) async {
    NetworkManager apiNetworkManager = GLOBALS.API_NETWORK_MANAGER;

    String api_target =
        "/api/vitalsign/${GLOBALS.USER_PROFILE.id}/?from=$timeFrom&to=$timeTo&type=$type";
    print('API_TARGET = $api_target');
    var response = await apiNetworkManager.request('GET', api_target);
    if (response.statusCode == 200) {
      var mappedResponse = jsonDecode(response.body);
      List a = mappedResponse;
      GLOBALS.FETCHED_RESPONSE = a;
      print(a.length);
    }
    print(response.body);
  }
}
