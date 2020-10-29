import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/pages/VS_Viz_New.dart';
import 'package:vital_signs_ui_template/pages/vital_signs_viz.dart';
import 'package:vital_signs_ui_template/Processing/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:vital_signs_ui_template/core/consts.dart';

class ConnectDevice extends StatelessWidget {
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
              return BluetoothOffScreen(state: state);
            }));
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state.toString().substring(15)}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
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
  final String DEVICE_ID = "66:55:44:33:22:11";
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
                    padding: EdgeInsets.fromLTRB(50, 150, 50, 0.0),
                    child: Text(
                      'Please enter your device ID',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        labelText: "66:55:44:33:22:11",
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
            SizedBox(height: 90),
            GestureDetector(
              onTap: () {
                scanAndConnect();
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
                    "CONNECT",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    scanAndConnect();
  }

  scanAndConnect() async {
    // Start scanning
    FlutterBlue.instance..startScan(timeout: Duration(seconds: 4));

// Listen to scan results
    FlutterBlue.instance
      ..scanResults.listen((results) {
        print('scan results below');

        for (ScanResult r in results) {
          print('name -- ${r.device.name} found! id: ${r.device.id}');

          if (r.device.id.toString() == DEVICE_ID) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              r.device.connect();
              return VisualizeVSnew(device: r.device);
            }));

//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) {
////              print('state ----- ${r.device.state}');
//                r.device.connect();
//                return VisualizeVSnew(device: r.device);
//              }),
//            );
          }
        }
      });

    // Stop scanning
    FlutterBlue.instance..stopScan();
  }
}
