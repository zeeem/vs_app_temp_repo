import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:system_setting/system_setting.dart';
import 'package:vital_signs_app/elements/ButtonWidget.dart';

import 'CustomAppBar.dart';

class BluetoothOffAlertScreen extends StatelessWidget {
  const BluetoothOffAlertScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

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
                      'Opps! It looks like your phone\'s Bluetooth Adapter is ${state.toString().substring(15)}!',
                      style: TextStyle(
                          fontSize: 21.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(50, 10, 50, 0.0),
                    child: Text(
                      'Please enable the Bluetooth Service from your phone settings by clicking below and then come back here again.',
                      style: TextStyle(
                          fontSize: 21.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ButtonWidget(
          buttonTitle: 'Go to Settings',
          secondaryButtonStyle: 1,
          onTapFunction: () {
            _jumpToBTSetting();
          }),
    );
  }
}

_jumpToBTSetting() {
  SystemSetting.goto(SettingTarget.BLUETOOTH);
}
