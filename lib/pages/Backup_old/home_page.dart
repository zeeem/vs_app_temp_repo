import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/pages/vital_signs_viz.dart';
import 'package:vital_signs_ui_template/Processing/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ConnectDevice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.lightBlue,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return TestBTScan();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
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

class TestBTScan extends StatefulWidget {
  @override
  _TestBTScanState createState() => _TestBTScanState();
}

class _TestBTScanState extends State<TestBTScan> {
  FlutterBlue flutterBlue2 = FlutterBlue.instance;
  final String DEVICE_ID = "66:55:44:33:22:11";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FloatingActionButton(
          onPressed: () {
            scanAndConnect();
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    scanAndConnect();
  }

  scanAndConnect() async {
    // Start scanning
    flutterBlue2.startScan(timeout: Duration(seconds: 4));

// Listen to scan results
    flutterBlue2.scanResults.listen((results) {
      print('scan results below');

      for (ScanResult r in results) {
        print('name -- ${r.device.name} found! id: ${r.device.id}');

        if (r.device.id.toString() == DEVICE_ID) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
//              print('state ----- ${r.device.state}');
              r.device.connect();
//              return SensorPage(device: r.device);
            }),
          );
        }
      }
    });

    // Stop scanning
    flutterBlue2.stopScan();
  }
}
