import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vital_signs_app/elements/CustomAppBar.dart';
import 'package:vital_signs_app/elements/TryAgainTemplate.dart';

import 'docPatientListPage.dart';

class DoctorSplashScreen extends StatefulWidget {
  @override
  _DoctorSplashScreenState createState() => _DoctorSplashScreenState();
}

class _DoctorSplashScreenState extends State<DoctorSplashScreen> {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => docPatientListPage()),
      );
    });

    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        turnOffBackButton: true,
        turnOffSettingsButton: true,
        height: 130, //no use of this fixed height
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: TryAgainPage(
          displayText: 'Welcome Dr. Smith!',
          displayText2: 'Connecting to your patients\' vitals',
          isLoadingVisible: true,
          userAsElement: true,
        ),
      ),
    );
  }
}
