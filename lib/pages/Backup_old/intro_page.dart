import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/configVS.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
//import 'registration/condition_page.dart';
import 'package:vital_signs_ui_template/pages/connectDevice.dart';
import 'package:vital_signs_ui_template/pages/registration/condition_page.dart';
import 'package:vital_signs_ui_template/pages/registration/configuration_page8.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.mainColor,
            AppColors.mainColor.withOpacity(.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: <Widget>[_buildHeader(), _buildFooter(context)],
      ),
    ));
  }

  Padding _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 200),
      child: Align(
        alignment: Alignment.topCenter,
        child: Image.asset("assets/images/splashicon.png"),
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
            Text(
              "Tracker for COVID-19",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                height: 1.5,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25),
            GestureDetector(
              onTap: () {
                if (profileData.PROFILE_CREATED) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ConfigurationPage8(
                        connectionMessage:
                            'Welcome back, ${profileData.USER_FULL_NAME}!',
                        buttonTitle: 'SHOW VITAL SIGNS',
                      ),
                    ),
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ConditionPage(),
                    ),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(1, 1),
                      spreadRadius: 1,
                      blurRadius: 3,
                    )
                  ],
                ),
                width: MediaQuery.of(context).size.width * .85,
                height: 60,
                child: Center(
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                      color: AppColors.mainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
