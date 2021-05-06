import 'package:flutter/material.dart';
//import 'package:flutter_blue/flutter_blue.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:rflutter_alert/rflutter_alert.dart';
//import 'package:vital_signs_app/elements/BluetoothOffAlert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vital_signs_app/Processing/NetworkGateway/networkManager.dart';
import 'package:vital_signs_app/core/configVS.dart';
import 'package:vital_signs_app/elements/ButtonWidget.dart';
import 'package:vital_signs_app/elements/CustomAppBar.dart';

//import 'package:vital_signs_app/pages/VS_Viz_New.dart';

import 'configuration_page8.dart';

bool needToTryAgain = false;

class ConfigurationPage7 extends StatefulWidget {
  @override
  _ConfigurationPage7 createState() => _ConfigurationPage7();
}

class _ConfigurationPage7 extends State<ConfigurationPage7> {
  final deviceIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  //use _save to save in shared preference
  _saveInSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();

    final doctorNameKey = 'DOCTOR_FULL_NAME';
    prefs.setString(doctorNameKey, profileData.DOCTOR_FULL_NAME);
    final doctorFacilityKey = 'DOCTOR_HEALTHCARE_FACILITY';
    prefs.setString(doctorFacilityKey, profileData.DOCTOR_HEALTHCARE_FACILITY);

    final userNameKey = 'USER_FULL_NAME';
    prefs.setString(userNameKey, profileData.USER_FULL_NAME);
    final userPhoneKey = 'USER_PHONE';
    prefs.setString(userPhoneKey, profileData.USER_PHONE);

    final contact1NameKey = 'EMERGENCY_CONTACT_1_NAME';
    prefs.setString(contact1NameKey, profileData.EMERGENCY_CONTACT_1_NAME);
    final contact1PhoneKey = 'EMERGENCY_CONTACT_1_PHONE';
    prefs.setString(contact1PhoneKey, profileData.EMERGENCY_CONTACT_1_PHONE);

    final contact2NameKey = 'EMERGENCY_CONTACT_2_NAME';
    prefs.setString(contact2NameKey, profileData.EMERGENCY_CONTACT_2_NAME);
    final contact2PhoneKey = 'EMERGENCY_CONTACT_2_PHONE';
    prefs.setString(contact2PhoneKey, profileData.EMERGENCY_CONTACT_2_PHONE);

    final contact3NameKey = 'EMERGENCY_CONTACT_3_NAME';
    prefs.setString(contact3NameKey, profileData.EMERGENCY_CONTACT_3_NAME);
    final contact3PhoneKey = 'EMERGENCY_CONTACT_3_PHONE';
    prefs.setString(contact3PhoneKey, profileData.EMERGENCY_CONTACT_3_PHONE);

    final deviceID = 'DEVICE_ID';
    prefs.setString(deviceID, profileData.DEVICE_ID);

    _saveInCloudDatabase();
  }

  _saveInCloudDatabase() async {
    Map<String, dynamic> map = {
      "username": "temp_username2",
      "email": "temp_email2@email.com",
      "height": "5.9",
      "weight": "68.4",
      "user_type": "1", //0 = patient, 1=doctor
      "phone": profileData.USER_PHONE.toString(),
      "date_of_birth": "1993-12-23",
      "gender": "0",
      "notes": "${profileData.DOCTOR_FULL_NAME.toString()}",
      "password": "123123",
      "first_name": profileData.USER_FULL_NAME.split(' ')[0].toString(),
      "last_name": profileData.USER_FULL_NAME.split(' ')[1].toString()
    };

    print('body====>> $map');

    NetworkManager apiNetworkManager = GLOBALS.API_NETWORK_MANAGER;
    var response =
        apiNetworkManager.request('POST', '/api/register/', body: map);
    print(response);
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
                      !needToTryAgain
                          ? 'Now, on the back of the device, there is a unique identifier code containing 5 Letters, Please enter this code here.'
                          : 'Opps! I could not connect your device! \nPlease try again.',
                      style: TextStyle(
                          fontSize: 21.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Device code',
                        hintText: '66:55:44:33:22:11',
                        labelStyle: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlue))),
                    controller: deviceIdController,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: ButtonWidget(
          buttonTitle: !needToTryAgain ? 'Next' : 'Try Again',
          onTapFunction: () {
            //saving PROFILE data in the static vars
            if (deviceIdController.text.isNotEmpty) {
              profileData.DEVICE_ID = deviceIdController.text;
              print('device id is not empty');
            } else {
              print('device id is empty, using default value');
            }

//           save all profile info in shared pref
            _saveInSharedPreference();

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ConfigurationPage8(),
              ),
            );
          }),
    );
  }
}

//return Fluttertoast.showToast(
//msg:
//"Could not find the device, click Next to search again.",
//toastLength: Toast.LENGTH_SHORT,
//gravity: ToastGravity.BOTTOM,
//timeInSecForIosWeb: 1,
//backgroundColor: Colors.black,
//textColor: Colors.white,
//fontSize: 14.0);
