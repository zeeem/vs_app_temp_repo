import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/elements/User.dart';
import 'package:vital_signs_ui_template/pages/doctor_pages/PatientInfo/patient_info_card.dart';

import '../../../elements/CustomAppBar.dart';

class PatientInfoScreen extends StatefulWidget {
  @override
  _PatientInfoScreenState createState() => _PatientInfoScreenState();
}

class _PatientInfoScreenState extends State<PatientInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return PatientInfo_Element();
  }
}

class PatientInfo_Element extends StatelessWidget {
  final String patient_name;
  final String patient_gender;
  final DateTime patient_DOB;
  final User clickedUser;

  const PatientInfo_Element(
      {Key key,
      this.patient_name = "Jack Brown",
      this.patient_gender = "Male",
      this.patient_DOB,
      this.clickedUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 40;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        height: 120,
        turnOffBackButton: false,
        turnOffSettingsButton: true,
      ),
      body: Container(
        //padding: EdgeInsets.fromLTRB(13, 20, 0, 0),
        child: Column(
          children: [
            Patient_info_card(
              full_width: width,
              patient_DOB: patient_DOB,
              patient_gender: patient_gender,
              clickedUser: clickedUser,
            ),
          ],
        ),
      ),
    );
  }
}
