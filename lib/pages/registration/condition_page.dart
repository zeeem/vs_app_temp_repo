import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'configuration_page1.dart';
import 'package:vital_signs_ui_template/pages/intro_page.dart';

import '../formsfill_page2.dart';
//import 'package:vital_signs_ui_template/pages/home_page.dart';
import 'package:flutter/gestures.dart';

class ConditionPage extends StatefulWidget {
  @override
  _ConditionPageState createState() => _ConditionPageState();
}

bool _value = true;

class _ConditionPageState extends State<ConditionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 130,
                    decoration: BoxDecoration(
                      color: AppColors.deccolor3,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.deccolor2,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                  ),
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.deccolor1,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(250),
                        bottomRight: Radius.circular(250),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(70, 130, 0, 0.0),
                    child: Text(
                      'Terms&Conditions',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
                width: 300,
                height: 400,
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
                child: Flexible(
                  child: Text(
                    'This will be our condition and terms: sasadf  sadf as gfdsg g  a we asdgasdf dsfds sdfg dsf gasfsa asdf asf asdas asd sa fsad fasd fsadf asf asd fdsga dsf g sdfg sas asdf asdf asdf asdf asd fsdaf sad fdsg dfsg sdfg dsfg dsfg sdf gdsfg sdfg asd fas fasd fasd fasd fsda dfsg sdfg dsfg zx as sadsa as f sad sfsad asd',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                  ),
                )),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.only(
                  top: 0.0, bottom: 20.0, left: 20.0, right: 0.0),
              child: CheckboxListTile(
                title: Text('I agree to the Terms and Conditions'),
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
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ConfigurationPage1(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.buttonColor,
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
                width: MediaQuery.of(context).size.width * .45,
                height: 60,
                child: Center(
                  child: Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
