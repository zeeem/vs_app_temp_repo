import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:vital_signs_app/core/configVS.dart';
import 'package:vital_signs_app/core/consts.dart';
import 'package:vital_signs_app/elements/BluetoothOffAlert.dart';
import 'package:vital_signs_app/elements/ButtonWidget.dart';
import 'package:vital_signs_app/elements/CustomAppBar.dart';
import 'package:vital_signs_app/pages/VS_Viz_New.dart';

import 'configuration_page9.dart';

bool needToTryAgain = false;
String _connectionMessage;
String _buttonTitle;
bool _isLoading = false;
bool _isProfileRegistered = false;
bool _isButtonVisible = true;
String _conErrorMsg;
int _tryCount = 0;
bool _turnOffBackButton = false;

//bool _isTestModeOn = false;

class ConfigurationPage8 extends StatefulWidget {
  final String connectionMessage;
  final String buttonTitle;
  final bool isProfileRegistered;
  final bool isButtonVisible;
  final bool turnOffBackButton;
  const ConfigurationPage8(
      {Key key,
      this.connectionMessage =
          'Thank you, now turn on the device and attach it to your wrist. When ready let me know I will pair the device with your phone.',
      this.buttonTitle = 'I AM READY',
      this.isProfileRegistered = false,
      this.isButtonVisible = true,
      this.turnOffBackButton = false})
      : super(key: key);
  @override
  _ConfigurationPage8 createState() => _ConfigurationPage8();
}

class _ConfigurationPage8 extends State<ConfigurationPage8> {
  @override
  void initState() {
    _connectionMessage = widget.connectionMessage;
    _buttonTitle = widget.buttonTitle;
    _isProfileRegistered = widget.isProfileRegistered;
    _isButtonVisible = widget.isButtonVisible;
    _turnOffBackButton = widget.turnOffBackButton;
    super.initState();
  }

  makeButtonVisible() {
    setState(() {
      _isButtonVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
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
    if (_isProfileRegistered) {
      enableLoading(true); //enable loading animation
      _tryCount += 1;
      var timer = Timer(Duration(seconds: 3), () async {
        await scanAndConnect(); //search and connect device and go to the VS page

//        Navigator.pushAndRemoveUntil(context, Viz, (e) => false); ////to pop the context
      });

      if (_tryCount > 1) {
        //2 = try 2 times, 1= once
        timer.cancel(); //turn off timer
        enableLoading(false); //turn off loading
        _conErrorMsg =
            'Could not find the device! \n \nPlease make sure the device is turned on and click the button below to try again.';
        setState(() {
          _connectionMessage = _conErrorMsg;
          _isButtonVisible = true;
        });
      }
    }

    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        height: 130, //no use of this fixed height
        turnOffBackButton: _turnOffBackButton,
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
            _isLoading
                ? Container(
                    child: Loading(
                      indicator: BallSpinFadeLoaderIndicator(),
                      size: 100.0,
                      color: AppColors.deccolor2,
                    ),
                  )
                : SizedBox(
                    width: 0,
                  ),
          ],
        ),
      ),
      bottomNavigationBar: _isButtonVisible
          ? ButtonWidget(
              buttonTitle: !needToTryAgain ? _buttonTitle : 'Try Again',
              onTapFunction: () async {
                //start scanning and connect to the DEVICE_ID
                //then go to the visualization page
                enableLoading(true);
                waitingToast(); //show a waiting toast
                await scanAndConnect();

//            if (_isTestModeOn) {
//              Navigator.of(context).push(
//                MaterialPageRoute(
//                  builder: (_) => ConfigurationPage9(),
//                ),
//              );
//            }
              })
          : SizedBox(
              width: 0,
            ),
    );
  }

  waitingToast() {
    Fluttertoast.showToast(
        msg: "Wait a moment, trying to connect the device.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0);
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

  enableLoading(bool boolValue) {
    setState(() {
      _isLoading = boolValue;
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
//        Fluttertoast.showToast(
//            msg:
//                "Could not find the device, \nclick $_buttonTitle to search again.",
//            toastLength: Toast.LENGTH_LONG,
//            gravity: ToastGravity.BOTTOM,
//            timeInSecForIosWeb: 1,
//            backgroundColor: Colors.black,
//            textColor: Colors.white,
//            fontSize: 14.0);
        if (_isButtonVisible) {
          setState(() {
            _connectionMessage =
                'Could not find the device! \n \nPlease make sure the device is turned on and click the button below to try again';
          });
        }
      } else {
        //if it connects then goto next page
        temp_device.connect().whenComplete(() {
          if (_isProfileRegistered) {
            makeToast('Connected!');
            setState(() {
              _connectionMessage = 'Device connected successfully!';
              _buttonTitle = 'Show Vital Signs';
            });

            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return VisualizeVSnew(device: temp_device);

//              return ConfigurationPage9(device: device);
            }));
          } else {
            makeToast('Connected!');
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//            return VisualizeVSnew(device: temp_device);
              return ConfigurationPage9(device: temp_device);
            }));
          }
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
      enableLoading(false); //resetting bool
    });
  }

  makeToast(String val) {
    Fluttertoast.showToast(
        msg: val,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0);
  }
}
