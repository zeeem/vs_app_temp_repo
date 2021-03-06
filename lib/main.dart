import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vital_signs_ui_template/core/configVS.dart';

import 'Processing/AlertSystem/AlertManagerPointData.dart';
import 'Processing/NetworkGateway/networkManager.dart';
import 'pages/UserSelectionPage.dart';

void main() {
  runApp(MyApp());
}

bool profileStatus = false;

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _readSharedPreference(); //reading from shared pref
    getAppInfo(); // getting app info (version, build number)
    initAlertManager(); //init the alert manager
    GLOBALS.API_NETWORK_MANAGER =
        NetworkManager(apiData.baseAPIurl, nursingHome: false);
    super.initState();
  }

  initAlertManager() async {
    await alertManager.init();
  }

  _readSharedPreference() async {
    final prefs = await SharedPreferences.getInstance().whenComplete(() {
      print('profile loaded');
    });

    //  print('user name -- ${prefs.containsKey('USER_FULL_NAME')}');
    //  print('dev id -- ${prefs.containsKey('DEVICE_ID')}');

    if (prefs.containsKey('DEVICE_ID')) {
      profileData.PROFILE_CREATED = true;
      profileData.USER_FULL_NAME = prefs.getString('USER_FULL_NAME');
      profileData.USER_PHONE = prefs.getString('USER_PHONE');
      profileData.DEVICE_ID = prefs.getString('DEVICE_ID');

      profileData.DOCTOR_FULL_NAME = prefs.getString('DOCTOR_FULL_NAME');

      profileData.DOCTOR_HEALTHCARE_FACILITY =
          prefs.getString('DOCTOR_HEALTHCARE_FACILITY');

      profileData.EMERGENCY_CONTACT_1_NAME =
          prefs.getString('EMERGENCY_CONTACT_1_NAME');
      profileData.EMERGENCY_CONTACT_2_NAME =
          prefs.getString('EMERGENCY_CONTACT_2_NAME');
      profileData.EMERGENCY_CONTACT_3_NAME =
          prefs.getString('EMERGENCY_CONTACT_3_NAME');

      profileData.EMERGENCY_CONTACT_1_PHONE =
          prefs.getString('EMERGENCY_CONTACT_1_PHONE');
      profileData.EMERGENCY_CONTACT_2_PHONE =
          prefs.getString('EMERGENCY_CONTACT_2_PHONE');
      profileData.EMERGENCY_CONTACT_3_PHONE =
          prefs.getString('EMERGENCY_CONTACT_3_PHONE');

      setState(() {
        profileStatus = true;
      });
    } else {
      profileData.PROFILE_CREATED = false;
    }

    print('login status ---- ${profileData.PROFILE_CREATED}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vital Signs App - Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: "OpenSans",
      ),
      home: () {
        return UserSelection(); //change to doctors page when needed
      }(), //docPatientListPage()LoginPage()AbnormalVsBoard
      // SplashScreen()UserSelectionPage
    );
  }
}

getAppInfo() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String appName = packageInfo.appName;
  String packageName = packageInfo.packageName;
  String version = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;

  profileData.appVersion = version;
  profileData.buildNumber = version;
}
