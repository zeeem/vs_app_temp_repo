import 'dart:convert';
import 'package:vital_signs_ui_template/Processing/NetworkGateway/networkManager.dart';
import 'package:vital_signs_ui_template/core/configVS.dart';
import 'package:vital_signs_ui_template/elements/ButtonWidget.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'registration/condition_page.dart';
import 'doctor_pages/docPatientListPage.dart';
import 'registration/configuration_page8.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final userNameController = TextEditingController();
  final userPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        height: 130, //no use of this fixed height
        turnOffSettingsButton: true,
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
                      'Sign in with your username and password',
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
                        labelText: 'Username or email',
                        labelStyle: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlue))),
                  ),
                  SizedBox(height: 30.0),
                  TextField(
                    controller: userPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlue))),
                  ),
                  SizedBox(height: 30.0),
                  FlatButton(
                    child: Text(
                      'Forgot password',
                      style: TextStyle(
                          color: AppColors.deccolor1,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    onPressed: () {},
                  ),
                  SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      FlatButton(
                        padding: EdgeInsets.all(1),
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            color: AppColors.deccolor1,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            // decoration: TextDecoration.underline,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ConditionPage()));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ButtonWidget(
        buttonTitle: 'Sign in',
        onTapFunction: () async {
          //saving PROFILE data in the static vars
          String username = userNameController.text;
          String password = userPasswordController.text;

          if (username.length > 1 && password.length > 1) {
            int statusCode = await logIntoAccount(username, password);
            print('code: $statusCode');
            if (statusCode == 200) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => docPatientListPage()
                    //     ConfigurationPage8(
                    //   connectionMessage:
                    //       'Wait a moment, ${profileData.USER_FULL_NAME}! \nI am connecting the device to show your vital signs.',
                    //   buttonTitle: 'TRY AGAIN',
                    //   isProfileRegistered: true,
                    //   isButtonVisible: false,
                    //   turnOffBackButton: true,
                    // ),
                    ),
              );
            } else {
              MakeToast('Incorrect username or password. Try Again.');
            }
          } else {
            MakeToast('Username or password is empty');
          }
        },
      ),
    );
  }

  Future<int> logIntoAccount(String username, String password) async {
    NetworkManager apiNetworkManager =
        NetworkManager(apiData.baseAPIurl, nursingHome: false);
    Map<String, dynamic> loginMap = {
      "username": "$username",
      "password": "$password"
    };

    var response =
        await apiNetworkManager.request('POST', '/api/login/', body: loginMap);
    if (response.statusCode == 200) {
      var mappedResponse = jsonDecode(response.body);
      profileData.userUUID = mappedResponse['id'];
    }

    return response.statusCode;
  }

  MakeToast(String toast_msg) {
    Fluttertoast.showToast(
        msg: "$toast_msg",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0);
  }
}