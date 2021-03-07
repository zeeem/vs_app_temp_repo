import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/Processing/NetworkGateway/networkManager.dart';
import 'package:vital_signs_ui_template/core/configVS.dart';
import 'package:vital_signs_ui_template/elements/ButtonWidget.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';

import 'configuration_page3_user_info.dart';

class ConfigurationPage2 extends StatefulWidget {
  @override
  _ConfigurationPage2 createState() => _ConfigurationPage2();
}

class _ConfigurationPage2 extends State<ConfigurationPage2> {
  final doctorNameController = TextEditingController();
  final doctorFacilityController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    // getDoctorsInfo(); //getting all doctor's info

    super.initState();
  }

//  getDirLocation() async {
//
//    File file = await File('$path/counter.txt');
//    file.writeAsString('this is test');
//  }

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
                      'The first thing I would like to ask you is the information about your doctor that is taking care of your health.',
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
                    controller: doctorNameController,
                    decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlue))),
                  ),
                  SizedBox(height: 30.0),
                  TextField(
                    controller: doctorFacilityController,
                    decoration: InputDecoration(
                        labelText: 'The health care facility of your doctor',
                        labelStyle: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.lightBlue))),
                  ),
                  SizedBox(height: 30.0),
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
          //saving PROFILE data in the static vars
          profileData.DOCTOR_FULL_NAME = doctorNameController.text;
          profileData.DOCTOR_HEALTHCARE_FACILITY =
              doctorFacilityController.text;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ConfigurationPage3(),
            ),
          );
        },
      ),
    );
  }

  // getDoctorsInfo() async{
  //
  //   NetworkManager apiNetworkManager = GLOBALS.API_NETWORK_MANAGER;
  //   var response = await apiNetworkManager.request('GET', '/api/shortdoctors/');
  //   var mappedResponse = jsonDecode(response.body);
  //
  //   print('end2');
  // }
}

_saveInCloudDatabase() async {
  Map<String, dynamic> map = {
    "username": "temp_username3",
    "email": "temp_email3@email.com",
    "height": "5.9",
    "weight": "68.4",
    "user_type": "0", //0 = patient, 1=doctor
    "phone": "7809098899",
    "date_of_birth": "1993-11-23",
    "gender": "0",
    "notes": "not applicable",
    "password": "123123",
    "first_name": "fn_user3",
    "last_name": "ln_user3"
  };

  print('body====>> $map');

  NetworkManager apiNetworkManager = GLOBALS.API_NETWORK_MANAGER;
  var response =
      await apiNetworkManager.request('POST', '/api/register/', body: map);
  print('responses body');
  print(response.body);
}
