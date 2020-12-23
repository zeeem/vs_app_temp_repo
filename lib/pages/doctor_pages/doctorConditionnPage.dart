import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:vital_signs_ui_template/elements/ButtonWidget.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';
import '../Backup_old/testPage.dart';
import 'package:flutter/services.dart' show rootBundle;
//import 'package:vital_signs_ui_template/pages/home_page.dart';
import 'package:flutter/gestures.dart';

import 'docPatientListPage.dart';

class DoctorConditionPage extends StatefulWidget {
  @override
  _DoctorConditionPageState createState() => _DoctorConditionPageState();
}

bool _value = false; //default value

class _DoctorConditionPageState extends State<DoctorConditionPage> {
  String termsAndCondition = 'Loading...';
  fetchTermsAndCondition() async {
    String responseText;
    responseText = await rootBundle.loadString('assets/texts/terms.txt');

    setState(() {
      termsAndCondition = responseText;
    });
  }

  @override
  void initState() {
    fetchTermsAndCondition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: CustomAppBar(
        height: 130, //no use of this fixed height
        turnOffBackButton: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
//                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0.0),
                  child: Text(
                    'Terms & Conditions',
                    style:
                    TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
                width: 300,
//              height: 400,
                padding: EdgeInsets.only(
                    top: 20.0, bottom: 20.0, left: 20.0, right: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(1, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    '$termsAndCondition',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                  ),
                )),
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.only(
                top: 0.0, bottom: 10.0, left: 10.0, right: 10.0),
            child: CheckboxListTile(
              title: Text('I agree to the Terms and Conditions*'),
              controlAffinity: ListTileControlAffinity.leading,
              value: _value,
              onChanged: (bool newValue) {
                setState(() {
                  _value = newValue;
                });
              },
              activeColor: AppColors.deccolor1,
              checkColor: Colors.white,
            ),
          ),
        ],
      ),
      bottomNavigationBar: ButtonWidget(
        buttonTitle: 'Next',
        onTapFunction: () {
          if (_value) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => docPatientListPage(),
              ),
            );
          } else {
            Fluttertoast.showToast(
                msg: "Please check the box to accept the terms and condition",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 14.0);
          }
        },
      ),
    );
  }
}
