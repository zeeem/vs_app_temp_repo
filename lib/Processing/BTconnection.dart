import 'dart:async';
import 'dart:collection';
import 'dart:convert' show utf8;
import 'dart:math';

import 'package:vital_signs_ui_template/core/configVS.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:vital_signs_ui_template/Processing/widgets.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:vital_signs_ui_template/elements/info_card.dart';
//import 'my_flutter_icons.dart';
import 'DataProcessing.dart';
import 'package:scidart/numdart.dart';
//import 'package:scidart/scidart.dart';
import 'fileManager.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:soundpool/soundpool.dart';

Array IR_raw_500 = Array.empty();
Array RED_raw_500 = Array.empty();

Array IR_raw_overlaped = Array.empty();
Array RED_raw_overlaped = Array.empty();

List warning_check_array =
    []; //to look into multiple reading for specific period and then issue warning
List temp_for_300sec = []; //temp data for 300 sec to check for warning

int count = 0;

bool isDeviceInUse = false; //checks if the device is being wore by the user
bool isCompareOn =
    false; //checks if it should record comparison data or raw data

double _final_hr = 0;
double _final_rr = 0;
double _final_spo2 = 0;
double _final_temp = 0;

//for comparison
double _comp_hr_300 = 0;
double _comp_rr_300 = 0;
double _comp_spo2_300 = 0;

String final_HR_to_show = '-';
String final_RR_to_show = '-';
String final_SPO2_to_show = '-';
String final_temp_to_show = '-';

var today = new DateTime.now();
final FileManager fileManager = FileManager('McGill_ble_rawData_$today.csv',
    onCache: false); //instantiating  file manager

//final FileManager fileManager2 = FileManager('Comparison_data_$today.csv',
//    onCache: false); //instantiating  file manager

//void main() {
////  runApp(FlutterBlueApp());
////}

class FlutterBlueApp extends StatefulWidget {
  @override
  _FlutterBlueAppState createState() => _FlutterBlueAppState();
}

class _FlutterBlueAppState extends State<FlutterBlueApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightGreen,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen();
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
      backgroundColor: Colors.lightGreen,
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
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
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

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text('Find and Connect McGill Device'),
//      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: AppColors.deccolor3,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                    ),
                    Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppColors.deccolor2,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.deccolor1,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(250),
                          bottomRight: Radius.circular(250),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(50, 105, 50, 15.0),
                      child: Text(
                        'Search and select your device',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map((d) => ListTile(
                            title: Text(d.name),
                            subtitle: Text(d.id.toString()),
                            trailing: StreamBuilder<BluetoothDeviceState>(
                              stream: d.state,
                              initialData: BluetoothDeviceState.disconnected,
                              builder: (c, snapshot) {
                                if (snapshot.data ==
                                    BluetoothDeviceState.connected) {
                                  return RaisedButton(
                                    child: Text('OPEN'),
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DeviceScreen(device: d))),
                                  );
                                }
                                return Text(snapshot.data.toString());
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map(
                        (r) => ScanResultTile(
                          result: r,
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            r.device.connect();
                            return DeviceScreen(device: r.device);
                          })),
                        ),
                      )
                      .toList(),
                ),
              ),
//              Container(
//                child: localConfigVS.isTestingModeOn
//                    ? RaisedButton(
//                        child: Text('Alert Test'),
//                        onPressed: () {
//                          var today = new DateTime.now();
//                          print('date-- $today');
////                          _issueWarningAlertBox(context);
//
////                    Navigator.push(
////                      context,
////                      MaterialPageRoute(builder: (context) => TestPageVis()),
////                    );
//                        },
//                      )
//                    : null,
//              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search),
                backgroundColor: AppColors.mainColor,
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({Key key, this.device}) : super(key: key);

  final BluetoothDevice device;

  //this is the device's advertising character UDID
  static String CHARACTERISTIC_UUID = '49535343-1e4d-4bd9-ba61-23c647249616';

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _myService(List<BluetoothService> services) {
    bool hr_warning = localConfigVS.hr_warning; //need to change it for warning

    Stream<List<int>> stream;

    services.forEach((service) {
      service.characteristics.forEach((character) {
        if (character.uuid.toString() == DeviceScreen.CHARACTERISTIC_UUID) {
          character.setNotifyValue(!character.isNotifying);
          stream = character.value;
        }
      });
    });

//    Future.delayed(Duration.zero, () => widget.device.connect());
//    Future.delayed(Duration.zero, () => widget.device.discoverServices());

    return Container(
      child: StreamBuilder<List<int>>(
          stream: stream,
          builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
            if (snapshot.hasError) return Text('Error : ${snapshot.error}');

            if (snapshot.connectionState == ConnectionState.active) {
              localConfigVS.isDeviceConnected = true;
              var decodedRawData = utf8.decode(snapshot.data);
//              List result_all = [0, 0, 0, 0, 0];
              //processing the raw data
              _parseProcessedData(snapshot.data);
//              if (localConfigVS.isWarningIssued) {
//                _issueWarningAlertBox(context);
//              }

              //issue the Alert Box only when the "isWarningIssued" is true
              if (localConfigVS.isWarningIssued) {
                Future.delayed(
                    Duration.zero, () => _issueWarningAlertBox(context));
              }

//              print('test result ---- $result_all');
              return SingleChildScrollView(
                child: Column(
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
                            padding: EdgeInsets.fromLTRB(20, 100, 50, 0.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Welcome, Daniel',
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black.withOpacity(.7)),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 50, 10, 0.0),
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
                                      builder: (context) => FlutterBlueApp()),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 0, top: 20, right: 0, bottom: 20),
                              width: double.infinity,
                              decoration: BoxDecoration(
//                      color: AppColors.mainColor.withOpacity(0.03),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50),
                                ),
                              ),
                              child: Center(
                                child: Center(
                                  child: Wrap(
                                    runSpacing: 20,
                                    spacing: 20,
                                    children: <Widget>[
                                      InfoCard(
                                        title: "Heart Rate",
                                        iconPath: 'assets/icons/hr_icon.png',
                                        valueUnit: 'bpm',
                                        valueToShow: '$final_HR_to_show',
                                        press: () {},
                                      ),
                                      InfoCard(
                                        title: "Temperature",
                                        iconPath: 'assets/icons/temp_icon.png',
                                        valueUnit: '°C',
                                        valueToShow: '$final_temp_to_show',
                                        press: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 0, top: 20, right: 0, bottom: 20),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.deccolor3.withOpacity(.1),
                                borderRadius: BorderRadius.circular(25),
//                      boxShadow: [
//                        BoxShadow(
//                          color: Colors.grey.withOpacity(0.05),
//                          spreadRadius: 1,
//                          blurRadius: 1,
//                          offset: Offset(1, 2), // changes position of shadow
//                        ),
//                      ],
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
//                          height: 40,
                                    width: 60,
                                    child: Image.asset(
                                        'assets/icons/spo2_icon.png'),
                                  ),
                                  SizedBox(width: 10),
                                  Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Oxygen Saturation',
                                          style: TextStyle(
                                              color: AppColors.textColor,
                                              fontSize: 17),
                                        ),
//                              SizedBox(height: 4),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              '$final_SPO2_to_show',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 35,
                                              ),
                                            ),
                                            SizedBox(width: 3),
                                            Text(
                                              '%',
                                              style: TextStyle(fontSize: 20),
//                                    textAlign: TextAlign.end,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 0, top: 20, right: 0, bottom: 20),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.deccolor3.withOpacity(.1),
                                borderRadius: BorderRadius.circular(25),
//                      boxShadow: [
//                        BoxShadow(
//                          color: Colors.grey.withOpacity(0.05),
//                          spreadRadius: 1,
//                          blurRadius: 1,
//                          offset: Offset(1, 2), // changes position of shadow
//                        ),
//                      ],
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
//                          height: 40,
                                    width: 60,
                                    child:
                                        Image.asset('assets/icons/rr_icon.png'),
                                  ),
                                  SizedBox(width: 10),
                                  Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Respiration Rate',
                                          style: TextStyle(
                                              color: AppColors.textColor,
                                              fontSize: 17),
                                        ),
//                              SizedBox(height: 4),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              '$final_RR_to_show',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 35,
                                              ),
                                            ),
                                            SizedBox(width: 3),
                                            Text(
                                              'rpm',
                                              style: TextStyle(fontSize: 20),
//                                    textAlign: TextAlign.end,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
//              Future.delayed(
//                  Duration.zero, () => connectDeviceALertBox(context));
              return Container(
                  padding: EdgeInsets.all(50), child: Text('Connected'));
//                Text(
//                'Connect the the device and click refresh button',
//                style: TextStyle(fontStyle: FontStyle.italic),
//              );
            }
          }),
    );
  }

////                      List<int> value = await c.read();
//                    },
//                    descriptorTiles: c.descriptors
//                        .map(
//                          (d) => DescriptorTile(
//                            descriptor: d,
//                            onReadPressed: () => d.read(),
//                            onWritePressed: () => d.write(_getRandomBytes()),
//                          ),
//                        )
//                        .toList(),
//                  ),
//                )
//                .toList(),
//          ),
//        )
//        .toList();
//  }

  connectDeviceALertBox(BuildContext context) async {
    widget.device.discoverServices();

    return StreamBuilder<List<BluetoothService>>(
      stream: widget.device.services,
      initialData: [],
      builder: (c, snapshot) {
        return _myService(snapshot.data);
      },
    );
//    return Alert(
//        context: context,
//        title: ' ${widget.device.name} CONNECTED! ID: ${widget.device.id}',
//        buttons: [
//          DialogButton(
//              child: Text(
//                'OKAY',
//                style:
//                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//                textAlign: TextAlign.center,
//              ),
//              color: AppColors.buttonColor,
//              onPressed: () {
//                widget.device.discoverServices();
//                Navigator.pop(context);
//                return StreamBuilder<List<BluetoothService>>(
//                  stream: widget.device.services,
//                  initialData: [],
//                  builder: (c, snapshot) {
//                    return _myService(snapshot.data);
//                  },
//                );
//              })
//        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    widget.device.connect();
    widget.device.discoverServices();

//    Future.delayed(
//        Duration(seconds: 3), () => widget.device.discoverServices());
//    Future.delayed(Duration.zero, () => widget.device.connect());
//    if (!localConfigVS.isDeviceConnected) {
//    Future.delayed(const Duration(milliseconds: 500), () => con_device(widget));
//    localConfigVS.isDeviceConnected = true;
//    }

    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.device.name),
//        actions: <Widget>[
//          StreamBuilder<BluetoothDeviceState>(
//            stream: widget.device.state,
//            initialData: BluetoothDeviceState.connecting,
//            builder: (c, snapshot) {
//              VoidCallback onPressed;
//              String text;
//              switch (snapshot.data) {
//                case BluetoothDeviceState.connected:
//                  onPressed = () => widget.device.disconnect();
//                  text = 'DISCONNECT';
//                  break;
//                case BluetoothDeviceState.disconnected:
//                  onPressed = () => widget.device.connect();
//                  text = 'CONNECT';
//                  break;
//                default:
//                  onPressed = null;
//                  text = snapshot.data.toString().substring(21).toUpperCase();
//                  break;
//              }
//              return FlatButton(
//                  onPressed: onPressed,
//                  child: Text(
//                    text,
//                    style: Theme.of(context)
//                        .primaryTextTheme
//                        .button
//                        .copyWith(color: Colors.white),
//                  ));
//            },
//          )
//        ],
//      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
//            Container(
//              child: Stack(
//                children: <Widget>[
//                  Container(
//                    height: 130,
//                    decoration: BoxDecoration(
//                      color: AppColors.deccolor3,
//                      borderRadius: BorderRadius.only(
//                        bottomLeft: Radius.circular(30),
//                        bottomRight: Radius.circular(30),
//                      ),
//                    ),
//                  ),
//                  Container(
//                    height: 100,
//                    decoration: BoxDecoration(
//                      color: AppColors.deccolor2,
//                      borderRadius: BorderRadius.only(
//                        bottomLeft: Radius.circular(50),
//                        bottomRight: Radius.circular(50),
//                      ),
//                    ),
//                  ),
//                  Container(
//                    height: 70,
//                    decoration: BoxDecoration(
//                      color: AppColors.deccolor1,
//                      borderRadius: BorderRadius.only(
//                        bottomLeft: Radius.circular(250),
//                        bottomRight: Radius.circular(250),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            ),
            !localConfigVS.isDeviceConnected
                ? StreamBuilder<BluetoothDeviceState>(
                    stream: widget.device.state,
                    initialData: BluetoothDeviceState.connecting,
                    builder: (c, snapshot) => ListTile(
                      leading: (snapshot.data == BluetoothDeviceState.connected)
                          ? Text('Press start to confirm')
                          : Container(),
//                          ? Icon(Icons.bluetooth_connected)
//                          : Icon(Icons.bluetooth_disabled),
//                title: Text(
//                    'Device is ${snapshot.data.toString().split('.')[1]}.'),
//                subtitle: Text('${widget.device.id}'),
                      trailing: StreamBuilder<bool>(
                        stream: widget.device.isDiscoveringServices,
                        initialData: false,
                        builder: (c, snapshot) => IndexedStack(
                          index: snapshot.data ? 1 : 0,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.play_circle_outline),
                              onPressed: () => widget.device.discoverServices(),
                            ),
//                      IconButton(
//                        icon: SizedBox(
//                          child: CircularProgressIndicator(
//                            valueColor: AlwaysStoppedAnimation(Colors.grey),
//                          ),
//                          width: 18.0,
//                          height: 18.0,
//                        ),
//                        onPressed: null,
//                      )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
//            StreamBuilder<int>(
//              stream: device.mtu,
//              initialData: 0,
//              builder: (c, snapshot) => ListTile(
//                title: Text('MTU Size'),
//                subtitle: Text('${snapshot.data} bytes'),
//                trailing: IconButton(
//                  icon: Icon(Icons.edit),
//                  onPressed: () => device.requestMtu(223),
//                ),
//              ),
//            ),
            StreamBuilder<List<BluetoothService>>(
              stream: widget.device.services,
              initialData: [],
              builder: (c, snapshot) {
                return _myService(snapshot.data);
              },
            ),
//            Container(
//              child: FloatingActionButton(
//                onPressed: () {
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(builder: (context) => TestPageVis()),
//                  );
//                },
//              ),
//            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            title: Text('Journal'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

_parseProcessedData(var rawData, [BuildContext context]) {
  final String decoded_value = utf8.decode(rawData);

  List val_list = decoded_value.split('	');

  List result;
  List result_normal300_iter; //for comparison

  print('_Val: ${val_list}');

  double _raw_temp;
  try {
    if (!isCompareOn) {
      //if not compare is false
      //storing raw data in csv file
      _storeRawData(val_list);
    }

    _raw_temp = double.tryParse(val_list.elementAt(0)) ?? 0; //temp
    double _raw_RED = double.tryParse(val_list.elementAt(5)); //RED
    double _raw_IR = double.tryParse(val_list.elementAt(6)); //IR

    //print('DONE - $_raw_IR $_raw_RED');

    RED_raw_500.add(_raw_RED); //for filtering and calculation
    IR_raw_500.add(_raw_IR); //for filtering and calculation

    if (RED_raw_overlaped.isEmpty) {
      //storing the previous data in the overlapped array
      RED_raw_overlaped.add(_raw_RED);
      IR_raw_overlaped.add(_raw_IR);
    } else {
      if (IR_raw_overlaped.length < 1800) {
        //max data to calculate is 1500 here
        RED_raw_overlaped.add(_raw_RED);
        IR_raw_overlaped.add(_raw_IR);
      } else {
        RED_raw_overlaped.removeRange(0, 300);
        IR_raw_overlaped.removeRange(0, 300);
      }
    }
  } catch (e) {
    _raw_temp = 0;
    print('parsing error, Check input format');
  }

//  //check if the device is in use (isDeviceInUse value will change)
//  if(_checkIfDeviceIsInUse(IR_raw_500.last)) {
//    try {
//      final_HR_to_show = 'Device not in use';
//    } catch (e) {
//      print('Device not in use');
//    }
//
//    try {
//      final_RR_to_show = 'Device not in use';
//    } catch (e) {
//      print('Device not in use');
//    }
//    try {
//      final_SPO2_to_show = 'Device not in use';
//    } catch (e) {
//      print('Device not in use');
//    }
//
//    final_temp_to_show = 'Device not in use';
//  }

  count++;
  if (count == 301) {
    //if only device is in use (isDeviceInUse is true)
    if (RED_raw_overlaped.isNotEmpty) {
      result = calculate_HR_RR_SPO2_TEMP(
          IR_raw_overlaped, RED_raw_overlaped, _raw_temp);

      if (isCompareOn) {
        //for comparison only
        result_normal300_iter =
            calculate_HR_RR_SPO2_TEMP(IR_raw_500, RED_raw_500, _raw_temp);
      }
    } else {
      //in case the overlap array is empty
      result = calculate_HR_RR_SPO2_TEMP(IR_raw_500, RED_raw_500, _raw_temp);
    }

    print('now calculating for ${RED_raw_overlaped.length} data');

    print('OUTPUT -- HR -- ${result[0]}');
    print('OUTPUT -- RR -- ${result[1]}');
    print('OUTPUT -- SPO2 -- ${result[2]}');
    print('OUTPUT -- Temp -- ${result[3]}');

    _final_hr = result[0];
    _final_rr = result[1];
    _final_spo2 = result[2];
    _final_temp = result[3];

    //for storing comparison data only - not needed other than to compare old computation method result only
    if (isCompareOn) {
      print('COMPARISON -- HR -- ${result_normal300_iter[0]}');
      print('COMPARISON -- RR -- ${result_normal300_iter[1]}');
      print('COMPARISON -- SPO2 -- ${result_normal300_iter[2]}');
      print('COMPARISON -- Temp -- ${result_normal300_iter[3]}');

      _comp_hr_300 = result_normal300_iter[0];
      _comp_rr_300 = result_normal300_iter[1];
      _comp_spo2_300 = result_normal300_iter[2];

      //creating a temporary list to hold all values for comparison
      List<int> comparison_processed_data = [
        _final_hr.toInt() ?? 0,
        _final_rr.toInt() ?? 0,
        _final_spo2.toInt() ?? 0,
        IR_raw_overlaped.length,
        _comp_hr_300.toInt() ?? 0, //hr - 300 data
        _comp_rr_300.toInt() ?? 0, //rr - 300 data
        _comp_spo2_300.toInt() ?? 0, //spo2 - 300 data
        IR_raw_500.length
      ];
      //storing comparison file
      _storeComparisonData(comparison_processed_data);

      print('array_comparison -- $comparison_processed_data');
    }

    try {
      final_HR_to_show = _final_hr.toStringAsFixed(0);
    } catch (e) {
      print('passing hr cal');
    }

    try {
      final_RR_to_show = _final_rr.toStringAsFixed(0);
    } catch (e) {
      print('passing rr cal');
    }
    try {
      final_SPO2_to_show = _final_spo2.toStringAsFixed(0);
    } catch (e) {
      print('passing spo2 cal');
    }

    final_temp_to_show = _final_temp.toStringAsFixed(1);

//    VS_Values.final_static_HR = final_HR_to_show;
//    VS_Values.final_static_RR = final_RR_to_show;
//    VS_Values.final_static_SPO2 = final_SPO2_to_show;
//    VS_Values.final_static_temp = final_temp_to_show;

    //check values and issue warning
    _checkAndIssueWarning(_final_hr, _final_rr, _final_spo2, _final_temp);

    IR_raw_500 = Array.empty();
    RED_raw_500 = Array.empty();
    count = 1;

//    if (count == 1) {
//      stopwatch = new Stopwatch()..start();
//    }
  }
}

//to store the raw data inside the device as csv
_storeRawData(List rawDatalist) {
  fileManager.createFile();
  int Tem = int.tryParse(rawDatalist[0]);
  int ACX = int.parse(rawDatalist[1]);
  int ACZ = int.parse(rawDatalist[2]);
  int BAT = int.parse(rawDatalist[3]);
  int RED = int.parse(rawDatalist[5]);
  int IR = int.parse(rawDatalist[6]);

  String timeNow = new DateTime.now().toString();

  fileManager.write_old(Tem, ACX, ACZ, BAT, RED, IR, timeNow);
  print('data added');
}

//to store the comparison data - not needed anymore
_storeComparisonData(
    List<int> hr1_rr1_spo1_calDataLen1_hr2o_rr2o_spo2o_calDataLen2) {
  fileManager.createFile();

  int hr_1 = hr1_rr1_spo1_calDataLen1_hr2o_rr2o_spo2o_calDataLen2[0];
  int rr_1 = hr1_rr1_spo1_calDataLen1_hr2o_rr2o_spo2o_calDataLen2[1];
  int spo2_1 = hr1_rr1_spo1_calDataLen1_hr2o_rr2o_spo2o_calDataLen2[2];
  int calDataLen1 = hr1_rr1_spo1_calDataLen1_hr2o_rr2o_spo2o_calDataLen2[3];
  int hr_2o = hr1_rr1_spo1_calDataLen1_hr2o_rr2o_spo2o_calDataLen2[4];
  int rr_2o = hr1_rr1_spo1_calDataLen1_hr2o_rr2o_spo2o_calDataLen2[5];
  int spo2_2o = hr1_rr1_spo1_calDataLen1_hr2o_rr2o_spo2o_calDataLen2[6];
  int calDataLen2 = hr1_rr1_spo1_calDataLen1_hr2o_rr2o_spo2o_calDataLen2[7];

  print(
      '$hr_1, $rr_1, $spo2_1, $calDataLen1, $hr_2o, $rr_2o, $spo2_2o, $calDataLen2');

  fileManager.write_v2(
      hr_1, rr_1, spo2_1, calDataLen1, hr_2o, rr_2o, spo2_2o, calDataLen2);

  print('comparison data added');
}

bool _checkIfDeviceIsInUse(double IR_value) {
  if (IR_value >= 1000) {
    isDeviceInUse = true;
  } else {
    isDeviceInUse = false;
  }
  return isDeviceInUse;
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

//function to check values and issue the warning for each 10 sec
_checkAndIssueWarning(double hr, double rr, double spo2, double temp,
    /*optional param*/ [BuildContext context]) async {
  //double hr, double rr, double spo2, double temp - are the processed data after each processing and display

  temp = temp +
      localConfigVS
          .warning_trigger_value_adder; //it will add 10 with final value just to simulate the temp warning

  //assuming we get 1 temp data after each 10 sec
  if (temp_for_300sec.length <= 30) {
    temp_for_300sec.add(temp);
  } else {
    temp_for_300sec = [];
  }

  //checking temp warning
  if (temp < localConfigVS.temp_threshold_range[0] ||
      temp >= localConfigVS.temp_threshold_range[1]) {
    localConfigVS.temp_warning = true;
  } else {
    localConfigVS.temp_warning = false;
  }

  //issue the warning alert box if any of the warning bool is true for the recent values
  if (localConfigVS.hr_warning ||
      localConfigVS.rr_warning ||
      localConfigVS.spo2_warning ||
      localConfigVS.temp_warning) {
    //----------------------------------------------------------
    //should look for multiple value to issue the warning alert
    //----------------------------------------------------------
    localConfigVS.isWarningIssued =
        true; //to issue the warning alert box and sound
  }

  print('Boolean changed ---- ${localConfigVS.temp_warning}');

  //for simulating alert
  if (localConfigVS.isTestingModeOn) {
    final_temp_to_show = temp.toStringAsFixed(1);
  }
}

//if any warning bool is true, issue the warning
_issueWarningAlertBox(BuildContext context) {
  //play warning sound
  _playWarningSound();

  // if test mode is on, RESET the 'value adder' after each simulation
  if (localConfigVS.isTestingModeOn) {
    localConfigVS.warning_trigger_value_adder = 0;
  }

  localConfigVS.isWarningIssued = false; //resetting warning trigger

  return Alert(
      context: context,
      title: 'You vital signs are low, Do you need emergency assistance?',
      buttons: [
        DialogButton(
          child: Text(
            'YES, I NEED HELP',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            Navigator.pop(context);
            return Alert(context: context, title: 'TOUCH TO CALL', buttons: [
              DialogButton(
                child: Text(
                  'CALL NUMBER 1',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
//                                        launch("tel://780708000");
                  _callNumber('780111000');
                },
              ),
              DialogButton(
                child: Text(
                  'CALL 911',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                onPressed: () {
                  _callNumber("911");
                },
                color: Colors.red,
              ),
            ]).show();
          },
          color: Colors.red,
        ),
        DialogButton(
          child: Text(
            'NO',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ]).show();
}

//con_device(State widget) async {
////  Future.delayed(Duration.zero, () => widget.device.connect());
//  Future.delayed(Duration.zero, () => widget.device.discoverServices());
//}
