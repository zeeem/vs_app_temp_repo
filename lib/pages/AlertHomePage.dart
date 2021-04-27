import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:soundpool/soundpool.dart';
import 'package:vital_signs_ui_template/Processing/AlertSystem/AlertManagerPointData.dart';
import 'package:vital_signs_ui_template/core/configVS.dart';
import 'package:vital_signs_ui_template/elements/ButtonWidget.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';
import 'package:vital_signs_ui_template/pages/Dashboard/AbnormalVsBoard.dart';

import 'doctor_pages/docPatientListPage.dart';

class AlertHomePage extends StatelessWidget {
  final String alert_text;
  final int backButtonType;
  const AlertHomePage(
      {Key key,
      this.alert_text =
          'Here are your contact numbers. Don\'t wait and click on a button to get assistance!',
      this.backButtonType = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double btn_height = 45;

    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        height: 130, //no use of this fixed height
//        turnOffBackButton: true,
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
                        scale: 1,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(40, 0, 40, 0.0),
                    child: Text(
                      '$alert_text',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
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
                  ButtonWidget(
                    buttonTitle: 'CALL ${profileData.DOCTOR_FULL_NAME}',
                    buttonHeight: btn_height,
                    secondaryButtonStyle: 2,
                    onTapFunction: () {
                      _callNumber('7804445140');
                    },
                  ),
                  ButtonWidget(
                    buttonTitle: 'CALL ${profileData.EMERGENCY_CONTACT_1_NAME}',
                    buttonHeight: btn_height,
                    onTapFunction: () {
                      _callNumber(profileData.EMERGENCY_CONTACT_1_PHONE);
                    },
                  ),
                  ButtonWidget(
                    buttonTitle: 'CALL ${profileData.EMERGENCY_CONTACT_2_NAME}',
                    buttonHeight: btn_height,
                    onTapFunction: () {
                      _callNumber(profileData.EMERGENCY_CONTACT_2_PHONE);
                    },
                  ),
                  ButtonWidget(
                    buttonTitle: 'CALL ${profileData.EMERGENCY_CONTACT_3_NAME}',
                    buttonHeight: btn_height,
                    onTapFunction: () {
                      _callNumber(profileData.EMERGENCY_CONTACT_3_PHONE);
                    },
                  ),
                ],
              ),
            ),
//            SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: ButtonWidget(
        buttonTitle:
            backButtonType <= 1 ? 'CANCEL' : 'I\'M OK! CHECK AGAIN IN 1H',
        secondaryButtonStyle: 4,
        buttonHeight: 50,
        onTapFunction: () {
          if (backButtonType <= 1) {
            Navigator.pop(context);
          } else {
            //delaying alarm for 1 hr
            alertManager.delayAlarm();
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}

//function to call the phone number directly
_callNumber(String phoneNumber) async {
//  const number = '08592119XXXX'; //set the number here
  bool res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
}

//function to play the warning sound
_playWarningSound() async {
  Soundpool pool = Soundpool(streamType: StreamType.notification);
  int soundId = await rootBundle
      .load('assets/sounds/warning_beep.mp3')
      .then((ByteData soundData) {
    return pool.load(soundData);
  });
  int streamId = await pool.play(soundId);
}

class AlterWindowV2 extends StatelessWidget {
  final String alert_text;
  final int backButtonType;

  const AlterWindowV2(
      {Key key,
      this.alert_text = 'Your Trusted Contacts',
      this.backButtonType = 1})
      : super(key: key);

  static double btn_height = 45;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(50, 40, 50, 0.0),
                    child: Align(
                      child: Image.asset(
                        "assets/images/vs_avatar_01.png",
                        scale: 1,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(40, 20, 40, 0.0),
                    child: Text(
                      '$alert_text',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
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
                  ButtonWidget(
                    buttonTitle:
                        'CALL ${profileData.DOCTOR_FULL_NAME ?? 'Hospital'}',
                    buttonHeight: btn_height,
                    secondaryButtonStyle: 2,
                    onTapFunction: () {
                      _callNumber('7804445140');
                    },
                  ),
                  ButtonWidget(
                    buttonTitle:
                        // 'CALL ${profileData.EMERGENCY_CONTACT_1_NAME ?? 'Daughter: Alison'}',
                        'CALL Daughter: Alison',
                    buttonHeight: btn_height,
                    onTapFunction: () {
                      _callNumber(profileData.EMERGENCY_CONTACT_1_PHONE);
                    },
                  ),
                  ButtonWidget(
                    buttonTitle:
                        // 'CALL ${profileData.EMERGENCY_CONTACT_2_NAME ?? 'Son: Brandon'}',
                        'CALL Son: Brandon',
                    buttonHeight: btn_height,
                    onTapFunction: () {
                      _callNumber(profileData.EMERGENCY_CONTACT_2_PHONE);
                    },
                  ),
                  ButtonWidget(
                    buttonTitle:
                        // 'CALL ${profileData.EMERGENCY_CONTACT_3_NAME ?? 'Friend: Steve'}',
                        'CALL Friend: Steve',
                    buttonHeight: btn_height,
                    onTapFunction: () {
                      _callNumber(profileData.EMERGENCY_CONTACT_3_PHONE);
                    },
                  ),
                  ButtonWidget(
                    buttonTitle: backButtonType <= 1
                        ? 'CANCEL'
                        : 'I\'M OK! CHECK AGAIN IN 1H',
                    secondaryButtonStyle: 4,
                    buttonHeight: 50,
                    buttonWidth: 200,
                    onTapFunction: () {
                      if (backButtonType <= 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AbnormalVsBoard(
                              selectedIndexToOpen: 0,
                            ),
                          ),
                        );
                      } else {
                        //delaying alarm for 1 hr
                        alertManager.delayAlarm();
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
//            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class contactPatientPage extends StatelessWidget {
  final String alert_text;
  final int backButtonType;
  final bool searchPatientToCall;

  const contactPatientPage(
      {Key key,
      this.alert_text = 'Do you want to call Jon?',
      this.backButtonType = 1,
      this.searchPatientToCall = false})
      : super(key: key);

  static double btn_height = 45;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(50, 20, 40, 0.0),
                    child: Align(
                      child: Image.asset(
                        "assets/images/vs_avatar_01.png",
                        scale: 1,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(40, 20, 40, 0.0),
                    child: Text(
                      '$alert_text',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            !searchPatientToCall
                ? Container(
                    padding:
                        EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        ButtonWidget(
                          buttonTitle: 'Call Home',
                          buttonHeight: btn_height,
                          secondaryButtonStyle: 5,
                          buttonIconData: Icons.call,
                          onTapFunction: () {
                            _callNumber('7804445140');
                          },
                        ),
                        ButtonWidget(
                          buttonTitle: 'Call Mobile',
                          buttonHeight: btn_height,
                          secondaryButtonStyle: 5,
                          buttonIconData: Icons.phone_android,
                          onTapFunction: () {
                            _callNumber('7804445140');
                          },
                        ),
                        ButtonWidget(
                          buttonTitle: 'Email',
                          buttonHeight: btn_height,
                          secondaryButtonStyle: 5,
                          buttonIconData: Icons.email,
                          onTapFunction: () {
                            _callNumber('7804445140');
                          },
                        ),
                        ButtonWidget(
                          buttonTitle: 'Emergency contacts',
                          buttonHeight: btn_height,
                          secondaryButtonStyle: 5,
                          buttonIconData: Icons.sms,
                          onTapFunction: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AbnormalVsBoard(
                                  //FIXME: need to fix the screen end point
                                  selectedIndexToOpen: 2,
                                ),
                              ),
                            );
                          },
                        ),
                        ButtonWidget(
                          buttonTitle: 'CANCEL',
                          secondaryButtonStyle: 2,
                          buttonHeight: 50,
                          onTapFunction: () {
                            if (backButtonType <= 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AbnormalVsBoard(
                                    selectedIndexToOpen: 0,
                                  ),
                                ),
                              );
                            } else {
                              //delaying alarm for 1 hr
                              alertManager.delayAlarm();
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    ),
                  )
                : Container(
                    child: ButtonWidget(
                      buttonTitle: 'Search & call',
                      buttonHeight: btn_height,
                      secondaryButtonStyle: 0,
                      buttonWidth: 300,
                      onTapFunction: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => docPatientListPage(
                              selectedIndex: 1,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
//            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
