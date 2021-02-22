import 'dart:math';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading/indicator/line_scale_indicator.dart';
import 'package:loading/loading.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';
import 'package:vital_signs_ui_template/elements/User.dart';
import 'package:vital_signs_ui_template/elements/info_card.dart';
import 'package:vital_signs_ui_template/pages/Dashboard/AbnormalVsBoard.dart';
import '../AlertHomePage.dart';
import 'HistoryPlots/HistoryPlot.dart';
import 'doctor_parient_history.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class docVsVisualizerPage extends StatefulWidget {
  final User clicked_user;
  final String doc_hr;
  final String doc_rr;
  final String doc_spo2;
  final String doc_temp;
  final String doc_bp;
  final int selectedIndexToOpen;

  const docVsVisualizerPage(
      {Key key,
      this.clicked_user,
      this.doc_hr = '78',
      this.doc_rr = '16',
      this.doc_spo2 = '99',
      this.doc_temp = '37',
      this.doc_bp = '125/85',
      this.selectedIndexToOpen = 0})
      : super(key: key);

  @override
  _docVsVisualizerPageState createState() => _docVsVisualizerPageState();
}

class _docVsVisualizerPageState extends State<docVsVisualizerPage> {
  List<dynamic> historyData = [];

  String _doc_hr;
  String _doc_rr;
  String _doc_spo2;
  String _doc_temp;
  String _doc_bp;
  User _clickedUser;
  int _selectedIndexBottomNavBtn = 0;

  int initialIndex = 0;
  DateTime now;

  String _userName;

  loadAsset() async {
    final myData = await rootBundle.loadString("assets/csv/dummy2.csv");

    //print(myData);
    List<dynamic> csvTable = CsvToListConverter().convert(myData);
    print(csvTable[0].last);

    historyData = csvTable;
    tempStaticVals.historyplot = historyData;

    // print(historyData);
  }

  @override
  void initState() {
    loadAsset();

    _doc_hr = widget.doc_hr;
    _doc_rr = widget.doc_rr;
    _doc_spo2 = widget.doc_spo2;
    _doc_temp = widget.doc_temp;
    _doc_bp = widget.doc_bp;

    _clickedUser = widget.clicked_user;
    _selectedIndexBottomNavBtn = widget.selectedIndexToOpen;

    now = DateTime.now();

    super.initState();

    if (_clickedUser != null) {
      _userName = _clickedUser.name;
    } else {
      _userName = '';
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndexBottomNavBtn = index;

      if (_selectedIndexBottomNavBtn == 0) {
        print('BottomNav index 0');
      } else if (_selectedIndexBottomNavBtn == 1) {
        print('BottomNav index 1');
      } else if (_selectedIndexBottomNavBtn == 2) {
        print('BottomNav index 2');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Random random = new Random();
    int sbp = 124 + random.nextInt(7);
    int dbp = 85 + random.nextInt(4);
    String rand_bp_to_show = '$sbp/$dbp';

    _doc_hr = (80 + random.nextInt(20)).toString();
    // _doc_hr = (120).toString();

    _doc_rr = (16 + random.nextInt(5)).toString();
    _doc_spo2 = (95 - random.nextInt(4)).toString();
    _doc_temp = (36.5 + random.nextInt(2)).toString();
    _doc_temp = (37 + random.nextInt(1)).toString();
    _doc_bp = rand_bp_to_show;

    _doc_hr = (120).toString();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: CustomAppBar(
            turnOffBackButton: false,
            turnOffSettingsButton: false,
            height: 130, //no use of this fixed height
          ),
          body: SingleChildScrollView(
            child: SafeArea(
                child: Column(
              children: [
                AnimatedSwitcher(
                    transitionBuilder: (widget, animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                                begin: Offset(.5, 0), end: Offset.zero)
                            .animate(animation),
                        child: widget,
                      );
                    },
                    duration: Duration(milliseconds: 300),
                    child: () {
                      switch (_selectedIndexBottomNavBtn) {
                        case 0:
                          return Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(20, 12, 0, 0),
                                    child: ToggleSwitch(
                                      minWidth: 82.0,
                                      minHeight: 40,
                                      //cornerRadius: 18.0,
                                      activeBgColor: AppColors.deccolor1,
                                      activeFgColor: Colors.white,
                                      inactiveBgColor: AppColors.deccolor3,
                                      inactiveFgColor: Colors.white,
                                      initialLabelIndex: initialIndex,
                                      labels: ['Now', 'History'],
                                      //icons: [FontAwesomeIcons.check, FontAwesomeIcons.times],
                                      onToggle: (index) {
                                        print('switched to: $index');
                                        setState(() {
                                          initialIndex = index;
                                        });
                                        //changeToggle(index);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              initialIndex == 0
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: doctorVSPage_element(
                                        clicked_user: _clickedUser,
                                      ),
                                    )
                                  : Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: AbnormalVSList(
                                        //userName: _userNam,
                                        userName: '',
                                        historyData: historyData,
                                      ),
                                    ),
                            ],
                          );
                        case 1:
                          return Container(
                              height: MediaQuery.of(context).size.height,
                              child: DoctorPatientHistory());

                        case 2:
                          return contactPatientPage(
                            alert_text:
                                "Do you want to call ${_userName.length > 0 ? _userName : 'Jon'}?",
                          );

                        default:
                          return AbnormalVSList(
                            userName: _userName,
                            historyData: historyData,
                          );
                      }
                    }()),
              ],
            )),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                title: Text('Vitals'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assessment),
                title: Text('Patient list'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.perm_phone_msg_rounded),
                title: Text('Contact'),
              ),
            ],
            currentIndex: 0,
            selectedItemColor: AppColors.deccolor1,
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }
}

class doctorVSPage_element extends StatelessWidget {
  final User clicked_user;
  final String doc_hr;
  final String doc_rr;
  final String doc_spo2;
  final String doc_temp;
  final String doc_bp;
  final bool turnOnToggleSwitch;

  const doctorVSPage_element(
      {Key key,
      this.clicked_user,
      this.doc_hr = '78',
      this.doc_rr = '16',
      this.doc_spo2 = '99',
      this.doc_temp = '37',
      this.doc_bp = '125/85',
      this.turnOnToggleSwitch = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List historyData = tempStaticVals.historyplot;
    User _clicked_user = clicked_user;
    String userName;
    if (_clicked_user != null) {
      userName = _clicked_user.name;
    } else {
      userName = '';
    }

    String _doc_hr = doc_hr;
    String _doc_rr = doc_rr;
    String _doc_spo2 = doc_spo2;
    String _doc_temp = doc_temp;
    String _doc_bp = doc_bp;
    DateTime now = DateTime.now();

    Random random = new Random();
    int sbp = 124 + random.nextInt(7);
    int dbp = 85 + random.nextInt(4);
    String rand_bp_to_show = '$sbp/$dbp';

    _doc_hr = (80 + random.nextInt(20)).toString();
    // _doc_hr = (120).toString();

    _doc_rr = (16 + random.nextInt(5)).toString();
    _doc_spo2 = (94 - random.nextInt(4)).toString();
    _doc_temp = (36.5 + random.nextInt(2)).toString();
    _doc_temp = (37 + random.nextInt(1)).toString();
    _doc_bp = rand_bp_to_show;

    _doc_spo2 = (89).toString();

    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(22, 10, 0, 0),
                    child: Text(
                      userName,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(.7)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 22, 0),
                    child: Text(
                      '${DateFormat().add_Md().add_jm().format(now)}',
                      style: TextStyle(
                          fontSize: 13.0,
                          // fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(.7)),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 0, top: 15, right: 0, bottom: 15),
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
                                  valueToShow: '${_doc_hr}',
                                  press: () {
                                    if (historyData.length > 0) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  HistoryPlot(
                                                    data: historyData,
                                                    expandedTitle: 'hr',
                                                  )));
                                    } else {
                                      return AlertDialog(
                                        title: Text('No history found'),
                                        content:
                                            Text('Do you want to try again?'),
                                        actions: <Widget>[
                                          FlatButton(
                                              onPressed: () {
                                                print('ignored');
                                              },
                                              child: Text('No')),
                                          new FlatButton(
                                              onPressed: () {
                                                tempStaticVals.loadAsset();
                                              },
                                              child: new Text('Yes')),
                                        ],
                                      );
                                    }
                                  },
                                ),
                                InfoCard(
                                  title: "Temperature",
                                  iconPath: 'assets/icons/temp_icon.png',
                                  valueUnit: '°C',
                                  valueToShow: '${_doc_temp}',
                                  press: () {
                                    if (historyData.length > 0) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  HistoryPlot(
                                                    data: historyData,
                                                    expandedTitle: 'temp',
                                                  )));
                                    } else {
                                      return AlertDialog(
                                        title: Text('No history found'),
                                        content:
                                            Text('Do you want to try again?'),
                                        actions: <Widget>[
                                          FlatButton(
                                              onPressed: () {
                                                print('ignored');
                                              },
                                              child: Text('No')),
                                          new FlatButton(
                                              onPressed: () {
                                                tempStaticVals.loadAsset();
                                              },
                                              child: new Text('Yes')),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 0),
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 0, top: 10, right: 0, bottom: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.deccolor3.withOpacity(.1),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
//                          height: 40,
                              width: 60,
                              child: Image.asset('assets/icons/spo2_icon.png'),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                if (historyData.length > 0) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HistoryPlot(
                                            data: historyData,
                                            expandedTitle: 'spo2',
                                          )));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          '${_doc_spo2}',
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
                              child: Image.asset('assets/icons/rr_icon.png'),
                            ),
                            SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                        '${_doc_rr}',
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
                              child: Image.asset('assets/icons/bp_icon.png'),
                            ),
                            SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Blood Pressure',
                                    style: TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 17),
                                  ),
//                              SizedBox(height: 4),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '${_doc_bp}', //widget.doc_bp
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 35,
                                        ),
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        'mmHg',
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
        ),
      ),
    );
  }
}
