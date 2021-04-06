import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/elements/User.dart';
import 'package:vital_signs_ui_template/pages/doctor_pages/AutoComplete/AutoCompleteDrugs.dart';

import '../../../core/configVS.dart';
import '../../../core/consts.dart';
import '../../Dashboard/vs_item.dart';
import '../docVSPage.dart';

class Patient_info_card extends StatefulWidget {
  final double full_width;
  final User clickedUser; // it has to be <UserProfile>
  // these two will come from <UserProfile>
  final String patient_gender;
  final DateTime patient_DOB;

  const Patient_info_card(
      {Key key,
      this.full_width,
      this.clickedUser,
      this.patient_gender,
      this.patient_DOB})
      : super(key: key);

  @override
  _Patient_info_cardState createState() => _Patient_info_cardState();
}

class _Patient_info_cardState extends State<Patient_info_card> {
  String medications = '';
  String diagnosis = '';
  String patientName = '';
  bool loaded = false;

  DateTime patient_DOB;
  String patient_gender;

  String iconPath = "";

  @override
  void initState() {
    patientName = widget.clickedUser.name ?? "";
    patient_DOB = widget.patient_DOB;
    patient_gender = widget.patient_gender;

    // if (PATIENT_INFO.medicationList == null) {
    //   PATIENT_INFO.medicationList = ['Tylenol', 'Aptiom', 'TEFLARO'];
    // }
    // if (PATIENT_INFO.diagnosisList == null) {
    //   PATIENT_INFO.diagnosisList = ['OCD', 'High BP', 'Heart Disease'];
    // }

    if (patient_gender.toLowerCase() == "male") {
      iconPath = "assets/icons/Male-icon.png";
    } else {
      iconPath = "assets/icons/Female-icon.png";
    }

    updateMedicationsAndDiagnosis();
    loaded = true;
    // TODO: implement initState
    super.initState();
  }

  updateMedicationsAndDiagnosis() {
    setState(() {
      medications = PATIENT_INFO.medicationList
          .toString()
          .replaceAll("[", "")
          .replaceAll(']', "");

      diagnosis = PATIENT_INFO.diagnosisList
          .toString()
          .replaceAll("[", "")
          .replaceAll(']', "");
    });

    medications = medications.length > 27
        ? medications.replaceRange(27, medications.length, "...")
        : medications;
    diagnosis = diagnosis.length > 27
        ? diagnosis.replaceRange(27, diagnosis.length, "...")
        : diagnosis;
  }

  @override
  Widget build(BuildContext context) {
    if (loaded) {
      setState(() {
        updateMedicationsAndDiagnosis();
      });
    }
    var w = widget.full_width / 2;
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("$patientName",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                      fontSize: 20,
                    )),
                TextButton(
                  onPressed: () {
                    updateMedicationsAndDiagnosis();
                  },
                  child: Icon(
                    Icons.info_outline,
                    color: AppColors.deccolor1,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            runSpacing: 10,
            spacing: 15,
            children: <Widget>[
              vs_item(
                maxWidth: w,
                valueFontSize: 25,
                title: 'Gender',
                valueToShow: '$patient_gender',
                valueUnit: '',
                iconPath: iconPath,
                // icon: Icon(Icons.account_box_sharp),
                maxHeight: 80,
              ),
              vs_item(
                maxWidth: w,
                valueFontSize: 25,
                title: 'DOB',
                valueToShow: "${patient_DOB.toLocal()}".split(' ')[0],
                valueUnit: '',
                iconPath: '',
                icon: Icon(
                  Icons.date_range_rounded,
                  size: 28,
                  color: AppColors.deccolor2,
                ),
                maxHeight: 80,
              ),
              vs_item_bp(
                title: 'Medications',
                valueFontSize: 22,
                valueToShow: medications,
                maxHeight: 90,
                valueUnit: '',
                iconPath: 'assets/icons/rx-icon.png',
                press: () async {
                  // navigateTo(context, AutoCompleteDrugs());
                  Function f;
                  f = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AutoCompleteDrugs()),
                  );
                  f();
                },
                maxWidth: widget.full_width + 12,
                bp_MAP_value: "",
              ),
              vs_item_bp(
                title: 'Diagnosis',
                valueFontSize: 22,
                valueToShow: diagnosis,
                maxHeight: 90,
                valueUnit: '',
                iconPath: 'assets/icons/diagnosis-icon.jpg',
                press: () {},
                maxWidth: widget.full_width + 12,
                bp_MAP_value: "",
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
            child: Text(
              "Normal Range",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColors.textColor,
              ),
              maxLines: 1,
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
            ),
          ),
          normalRangeTile(),
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.fromLTRB(20, 10, 15, 0),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.greenButton)),
              child: const Text('Open Vital Signs'),
              onPressed: () {
                if (widget.clickedUser != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          docVsVisualizerPage(clicked_user: widget.clickedUser),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class normalRangeTile extends StatelessWidget {
  double fontSize = 23;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Wrap(
          runSpacing: 10,
          spacing: 15,
          children: <Widget>[
            vs_item(
              title: 'HR',
              valueToShow: '60/100',
              valueUnit: 'bpm',
              iconPath: 'assets/icons/hr_icon.png',
              press: () async {},
              valueFontSize: fontSize,
            ),
            vs_item(
              title: 'TEMP',
              valueToShow: '36/37.5',
              valueUnit: '°C',
              iconPath: 'assets/icons/temp_icon2.png',
              press: () {
                print('test click');
              },
              valueFontSize: fontSize,
            ),
            vs_item(
              title: 'SPO2',
              valueToShow: '90/100',
              valueUnit: '%',
              iconPath: 'assets/icons/spo2_icon.png',
              press: () async {},
              valueFontSize: fontSize,
            ),
            vs_item(
              title: 'RR',
              valueToShow: '14/18',
              valueUnit: 'rpm',
              iconPath: 'assets/icons/rr_icon.png',
              press: () {},
              valueFontSize: fontSize,
            ),
            vs_item_bp(
              title: 'BP',
              valueToShow: '80/120',
              valueUnit: 'mmHg',
              iconPath: 'assets/icons/bp_icon.png',
              press: () {},
              maxWidth: 235,
              bp_MAP_value: '',
              valueFontSize: fontSize,
            ),
          ],
        ),
      ),
    );
  }
}

navigateTo(BuildContext context, var pageToNavigate) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => pageToNavigate),
  );
  // LoginPage()AbnormalVsBoard
}
