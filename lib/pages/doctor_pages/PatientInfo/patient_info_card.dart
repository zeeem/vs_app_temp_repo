import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/pages/doctor_pages/AutoComplete/AutoCompleteDrugs.dart';

import '../../../core/configVS.dart';
import '../../../core/consts.dart';
import '../../Dashboard/vs_item.dart';

class Patient_info_card extends StatefulWidget {
  final double full_width;

  const Patient_info_card({Key key, this.full_width}) : super(key: key);

  @override
  _Patient_info_cardState createState() => _Patient_info_cardState();
}

class _Patient_info_cardState extends State<Patient_info_card> {
  final TextEditingController _textEditingController = TextEditingController();
  String medications = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      medications = PATIENT_INFO.medicationList
          .toString()
          .replaceAll("[", "")
          .replaceAll(']', "");
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = widget.full_width / 2;
    return Container(
      child: Column(
        children: [
          Wrap(
            runSpacing: 10,
            spacing: 15,
            children: <Widget>[
              vs_item(
                maxWidth: w,
                valueFontSize: 30,
                title: 'Gender',
                valueToShow: 'Male',
                valueUnit: '',
                iconPath: 'assets/icons/hr_icon.png',
              ),
              vs_item(
                maxWidth: w,
                valueFontSize: 30,
                title: 'DOB',
                valueToShow: '21-04-1980',
                valueUnit: '',
                iconPath: 'assets/icons/hr_icon.png',
              ),
              vs_item_bp(
                title: 'Medications',
                valueFontSize: 22,
                valueToShow: medications,
                maxHeight: 110,
                valueUnit: '',
                iconPath: 'assets/icons/bp_icon.png',
                press: () {
                  navigateTo(context, AutoCompleteDrugs());
                },
                maxWidth: widget.full_width + 12,
                bp_MAP_value: "",
              ),
              vs_item_bp(
                title: 'Diagnosis',
                valueFontSize: 22,
                valueToShow: 'OCD, CKD, BP...',
                maxHeight: 110,
                valueUnit: '',
                iconPath: 'assets/icons/bp_icon.png',
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
