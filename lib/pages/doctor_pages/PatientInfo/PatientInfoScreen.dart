import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/pages/doctor_pages/PatientInfo/patient_info_card.dart';

import '../../../elements/CustomAppBar.dart';

class PatientInfoScreen extends StatefulWidget {
  @override
  _PatientInfoScreenState createState() => _PatientInfoScreenState();
}

class _PatientInfoScreenState extends State<PatientInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 120,
        turnOffBackButton: true,
        turnOffSettingsButton: true,
      ),
      body: PatientInfo_Element(),
    );
  }
}

class PatientInfo_Element extends StatefulWidget {
  @override
  _PatientInfo_ElementState createState() => _PatientInfo_ElementState();
}

class _PatientInfo_ElementState extends State<PatientInfo_Element> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 40;
    return Container(
      //padding: EdgeInsets.fromLTRB(13, 20, 0, 0),
      child: Column(
        children: [
          Patient_info_card(
            full_width: width,
          ),
        ],
      ),
    );
  }
}
