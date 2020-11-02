import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vital_signs_ui_template/elements/BluetoothOffAlert.dart';
import 'package:vital_signs_ui_template/elements/ButtonWidget.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';
import 'package:vital_signs_ui_template/pages/VS_Viz_New.dart';
import 'package:vital_signs_ui_template/pages/registration/profile_page.dart';

import 'configuration_page9.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:vital_signs_ui_template/core/configVS.dart';

bool needToTryAgain = false;
String _connectionMessage;
String _buttonTitle;

class ConfigurationPage8 extends StatefulWidget {
  final String connectionMessage;
  final String buttonTitle;
  const ConfigurationPage8(
      {Key key,
      this.connectionMessage =
          'Thank you, now turn on the device and attach it to your wrist. When ready let me know I will pair the device with your phone',
      this.buttonTitle = 'I AM READY'})
      : super(key: key);
  @override
  _ConfigurationPage8 createState() => _ConfigurationPage8();
}

class _ConfigurationPage8 extends State<ConfigurationPage8> {
  @override
  void initState() {
    _connectionMessage = widget.connectionMessage;
    _buttonTitle = widget.buttonTitle;

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
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0.0),
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(
                            Icons.settings,
                            color: AppColors.textColor,
                            size: 40,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
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
                    padding: EdgeInsets.fromLTRB(50, 10, 50, 0.0),
                    child: Text(
                      '$_connectionMessage',
                      style: TextStyle(
                          fontSize: 21.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: ButtonWidget(
          buttonTitle: !needToTryAgain ? _buttonTitle : 'Try Again',
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
            msg:
                "Could not find the device, \nclick 'I AM READY' to search again.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 14.0);
      } else {
        //if it connects then goto next page
        temp_device.connect().whenComplete(() {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//            return VisualizeVSnew(device: temp_device);
            return ConfigurationPage9(device: temp_device);
          }));
        });
//
//        Fluttertoast.showToast(
//            msg: "Could not connect! \nPlease try again.",
//            toastLength: Toast.LENGTH_SHORT,
//            gravity: ToastGravity.BOTTOM,
//            timeInSecForIosWeb: 1,
//            backgroundColor: Colors.black,
//            textColor: Colors.white,
//            fontSize: 14.0);
      }
    });
  }
}
