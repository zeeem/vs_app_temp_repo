import 'dart:async';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:vital_signs_ui_template/core/configVS.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/pages/Backup_old/intro_page.dart';
import 'package:vital_signs_ui_template/pages/registration/condition_page.dart';
import 'package:vital_signs_ui_template/pages/registration/configuration_page8.dart';

import 'LoginPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 4), () {
      if (profileData.PROFILE_CREATED) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ConfigurationPage8(
              connectionMessage:
                  'Wait a moment, ${profileData.USER_FULL_NAME}! \nI am connecting the device to show your vital signs.',
              buttonTitle: 'TRY AGAIN',
              isProfileRegistered: true,
              isButtonVisible: false,
              turnOffBackButton: true,
            ),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>
                LoginPage())); //ConditionPage()LoginPage
      }
    });

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.mainColor,
              AppColors.mainColor.withOpacity(.5),
              AppColors.mainColor.withOpacity(.1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[_buildHeader(), _buildFooter(context)],
        ),
      ),
    );
  }

  Padding _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 200),
      child: Align(
        alignment: Alignment.topCenter,
        child: Image.asset("assets/images/splashicon_v2.png"),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Positioned(
      bottom: 50,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Loading(
              indicator: BallSpinFadeLoaderIndicator(),
              size: 80,
              color: AppColors.deccolor3,
            ),
            SizedBox(height: 50),
            Text(
              "Your personal healthcare network",
              style: TextStyle(
                fontSize: 20,
                color: AppColors.textColor,
                // height: 1.5,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            // Text(
            //   profileData.appVersion.length > 1
            //       ? "version ${profileData.appVersion}"
            //       : "",
            //   style: TextStyle(
            //     fontSize: 15,
            //     color: Colors.black,
            //     // height: 1.5,
            //     // fontWeight: FontWeight.bold,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
