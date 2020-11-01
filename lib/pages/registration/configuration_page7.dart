import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:vital_signs_ui_template/elements/BluetoothOffAlert.dart';
import 'package:vital_signs_ui_template/elements/ButtonWidget.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';
import 'package:vital_signs_ui_template/pages/VS_Viz_New.dart';

import 'configuration_page8.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:vital_signs_ui_template/core/configVS.dart';

bool needToTryAgain = false;
int _count_temporary = 0;

class ConfigurationPage7 extends StatefulWidget {
  @override
  _ConfigurationPage7 createState() => _ConfigurationPage7();
}

class _ConfigurationPage7 extends State<ConfigurationPage7> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) {
            return StartBTScanAndAutoConnect();
          }
          return BluetoothOffAlertScreen(state: state);
        },
      ),
    );
  }
}

class StartBTScanAndAutoConnect extends StatefulWidget {
  @override
  _StartBTScanAndAutoConnectState createState() =>
      _StartBTScanAndAutoConnectState();
}

class _StartBTScanAndAutoConnectState extends State<StartBTScanAndAutoConnect> {
//  FlutterBlue flutterBlue2 = FlutterBlue.instance;
  final String DEVICE_ID = profileData.DEVICE_ID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
          onTapFunction: () async {
            //start scanning and connect to the DEVICE_ID
            //then go to the visualization page
            await scanAndConnect();

//            Navigator.of(context).push(
//              MaterialPageRoute(
//                builder: (_) => ConfigurationPage8(),
//              ),
//            );
          }),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    scanAndConnect();
    checkIfTryAgain();
  }

  checkIfTryAgain() {
    setState(() {
      needToTryAgain = profileData.needToTryAgain;
    });
  }

  scanAndConnect() async {
    List<String> found_device_ids = [];
    // Start scanning
    FlutterBlue.instance..startScan(timeout: Duration(seconds: 4));

    BluetoothDevice temp_device;
    // Listen to scan results
    FlutterBlue.instance
      ..scanResults.listen((results) {
        print('scan results below');

        for (ScanResult r in results) {
          print('name -- ${r.device.name} found! id: ${r.device.id}');

          found_device_ids.add(r.device.id.toString());
          print('devices found ---- ${found_device_ids.length}');

          if (r.device.id.toString() == DEVICE_ID) {
//            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//              r.device.connect();
//              return VisualizeVSnew(device: r.device);
//            }));
            temp_device = r.device;

            break;
          }
        }
      });

//    _count_temporary += 1;

    // Stop scanning
    FlutterBlue.instance..stopScan();

    new Timer(const Duration(seconds: 4), () {
      if (!found_device_ids.contains(DEVICE_ID)) {
        print('NO DEVICE FOUND');
        Fluttertoast.showToast(
            msg: "Could not find the device, click Next to search again.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 14.0);
      } else {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          temp_device.connect();
          return VisualizeVSnew(device: temp_device);
        }));
      }
    });

//    if (_count_temporary >= 1) {
//      print('counting iter ---- $_count_temporary');
//      print('devices found ---- $found_device_ids');
//
////      return Alert(
////        context: context,
////        title:
////            'Could not find the device, Please make sure the Device ID is correct and click Next again.',
////        buttons: [
////          DialogButton(
////            child: Text(
////              'OKAY',
////              style:
////                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
////              textAlign: TextAlign.center,
////            ),
////            onPressed: () {
////              Navigator.pop(context);
////            },
////            color: AppColors.deccolor1,
////          ),
////        ],
////      ).show();
//    }
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
