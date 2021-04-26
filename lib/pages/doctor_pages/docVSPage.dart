import 'dart:math';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';
import 'package:vital_signs_ui_template/elements/User.dart';
import 'package:vital_signs_ui_template/elements/info_card.dart';
import 'package:vital_signs_ui_template/pages/Dashboard/AbnormalVsBoard.dart';

import '../AlertHomePage.dart';
import 'HistoryPlots/StickyHeaderPlots.dart';
import 'PatientInfo/PatientInfoScreen.dart';
import 'doctor_patient_history.dart';
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
      this.doc_temp = '37.5',
      this.doc_bp = '125/85',
      this.selectedIndexToOpen = 1})
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
  int _selectedIndexBottomNavBtn = 1;

  int initialIndex = 1;
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
    _doc_temp = (36.5 + random.nextInt(1)).toString();
    // _doc_temp = (37 + random.nextInt(1)).toString();
    _doc_bp = rand_bp_to_show;

    // _doc_hr = (104).toString();
    // _doc_spo2 = (89).toString();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          // resizeToAvoidBottomPadding: false,
          resizeToAvoidBottomInset: false, //FIXME
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
                          return Container(
                              height: MediaQuery.of(context).size.height,
                              child: DoctorPatientSearch());
                        case 1:
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
                              AnimatedSwitcher(
                                transitionBuilder: (widget, animation) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                            begin: Offset(.5, 0),
                                            end: Offset.zero)
                                        .animate(animation),
                                    child: widget,
                                  );
                                },
                                duration: Duration(milliseconds: 300),
                                child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  child: initialIndex == 0
                                      ? doctorVSPage_element(
                                          clicked_user: _clickedUser,
                                        )
                                      : AbnormalVSList(
                                          //userName: _userNam,
                                          userName: '',
                                          historyData: historyData,
                                        ),
                                ),
                              ),
                              // initialIndex == 0
                              //     ? Container(
                              //         height:
                              //             MediaQuery.of(context).size.height,
                              //         child: doctorVSPage_element(
                              //           clicked_user: _clickedUser,
                              //         ),
                              //       )
                              //     : Container(
                              //         height:
                              //             MediaQuery.of(context).size.height,
                              //         child: AbnormalVSList(
                              //           //userName: _userNam,
                              //           userName: '',
                              //           historyData: historyData,
                              //         ),
                              //       ),
                            ],
                          );
                        case 2:
                          return contactPatientPage(
                            alert_text:
                                "Do you want to contact ${_userName.length > 0 ? _userName : 'Jon'}?",
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
                icon: Icon(Icons.view_list_outlined),
                title: Text('Patient List'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                title: Text('Vitals'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.perm_phone_msg_rounded),
                title: Text('Contact'),
              ),
            ],
            currentIndex: _selectedIndexBottomNavBtn,
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
      this.doc_temp = '37.5',
      this.doc_bp = '125/85',
      this.turnOnToggleSwitch = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<int> bp_val = [130, 90];

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
    int bp_MAP = (1 / 3 * sbp + 2 / 3 * dbp).truncate();

    String rand_bp_to_show = '$sbp/$dbp ($bp_MAP)';

    _doc_hr = (80 + random.nextInt(15)).toString();
    // _doc_hr = (120).toString();

    _doc_rr = (16 + random.nextInt(5)).toString();
    _doc_spo2 = (94 - random.nextInt(4)).toString();
    _doc_temp = (37.5 + random.nextInt(1)).toString();
    // _doc_temp = (37 + random.nextInt(1)).toString();
    _doc_bp = rand_bp_to_show;

    // _doc_spo2 = (91).toString();
    // _doc_spo2 = (89).toString();
    // _doc_spo2 = (101).toString();

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
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PatientInfo_Element(
                              clickedUser: _clicked_user,
                              patient_gender: "Male",
                              patient_DOB: new DateTime(1980, 12, 15),
                            ),
                          ),
                        );
                      },
                      child: userName.length > 0
                          ? Wrap(
                              children: [
                                Text(
                                  userName,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black.withOpacity(.7)),
                                ),
                                Icon(
                                  Icons.info_outline,
                                  color: AppColors.deccolor1,
                                  size: 20,
                                ),
                              ],
                            )
                          : Container(),
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
                                    navigateTo(
                                        context,
                                        VSPlotWithStickyHeader(
                                          clickedVS: "HR",
                                        ));

                                    // if (historyData.length > 0) {
                                    //   Navigator.of(context).push(
                                    //       MaterialPageRoute(
                                    //           builder: (BuildContext context) =>
                                    //               HistoryPlot(
                                    //                 data: historyData,
                                    //                 expandedTitle: 'hr',
                                    //               )));
                                    //   navigateTo(context, VSplotExample());
                                    // } else {
                                    //   return AlertDialog(
                                    //     title: Text('No history found'),
                                    //     content:
                                    //         Text('Do you want to try again?'),
                                    //     actions: <Widget>[
                                    //       FlatButton(
                                    //           onPressed: () {
                                    //             print('ignored');
                                    //           },
                                    //           child: Text('No')),
                                    //       new FlatButton(
                                    //           onPressed: () {
                                    //             tempStaticVals.loadAsset();
                                    //           },
                                    //           child: new Text('Yes')),
                                    //     ],
                                    //   );
                                    // }
                                  },
                                ),
                                InfoCard(
                                  title: "Temperature",
                                  iconPath: 'assets/icons/temp_icon.png',
                                  valueUnit: '°C',
                                  valueToShow: '${_doc_temp}',
                                  press: () {
                                    navigateTo(
                                        context,
                                        VSPlotWithStickyHeader(
                                          clickedVS: "TEMP",
                                        ));
                                    // if (historyData.length > 0) {
                                    // Navigator.of(context).push(
                                    //     MaterialPageRoute(
                                    //         builder: (BuildContext context) =>
                                    //             HistoryPlot(
                                    //               data: historyData,
                                    //               expandedTitle: 'temp',
                                    //             )));
                                    // } else {
                                    //   return AlertDialog(
                                    //     title: Text('No history found'),
                                    //     content:
                                    //         Text('Do you want to try again?'),
                                    //     actions: <Widget>[
                                    //       FlatButton(
                                    //           onPressed: () {
                                    //             print('ignored');
                                    //           },
                                    //           child: Text('No')),
                                    //       new FlatButton(
                                    //           onPressed: () {
                                    //             tempStaticVals.loadAsset();
                                    //           },
                                    //           child: new Text('Yes')),
                                    //     ],
                                    //   );
                                    // }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
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
                                  title: "SPO2",
                                  iconPath: 'assets/icons/spo2_icon.png',
                                  valueUnit: '%',
                                  valueToShow: '${_doc_spo2}',
                                  press: () {
                                    navigateTo(
                                        context,
                                        VSPlotWithStickyHeader(
                                          clickedVS: "SPO2",
                                        ));

                                    // if (historyData.length > 0) {
                                    //   Navigator.of(context).push(
                                    //       MaterialPageRoute(
                                    //           builder: (BuildContext context) =>
                                    //               HistoryPlot(
                                    //                 data: historyData,
                                    //                 expandedTitle: 'spo2',
                                    //               )));

                                    // } else {
                                    //   return AlertDialog(
                                    //     title: Text('No history found'),
                                    //     content:
                                    //         Text('Do you want to try again?'),
                                    //     actions: <Widget>[
                                    //       FlatButton(
                                    //           onPressed: () {
                                    //             print('ignored');
                                    //           },
                                    //           child: Text('No')),
                                    //       new FlatButton(
                                    //           onPressed: () {
                                    //             tempStaticVals.loadAsset();
                                    //           },
                                    //           child: new Text('Yes')),
                                    //     ],
                                    //   );
                                    // }
                                  },
                                ),
                                InfoCard(
                                  title: "RR",
                                  iconPath: 'assets/icons/rr_icon.png',
                                  valueUnit: '°C',
                                  valueToShow: '${_doc_rr}',
                                  press: () {
                                    navigateTo(
                                        context,
                                        VSPlotWithStickyHeader(
                                          clickedVS: "RR",
                                        ));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    vsLive_item_bp(
                      title: 'Blood Pressure',
                      valueToShow: '${bp_val[0]}/${bp_val[1]}',
                      valueUnit: 'mmHg',
                      iconPath: 'assets/icons/bp_icon.png',
                      press: () {},
                      maxWidth: 400,
                      bp_MAP_value: bp_MAP.toString(),
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

class vs_horizontal_card extends StatelessWidget {
  final String vs_name;
  final String vs_value;
  final String vs_unit;
  final String vs_icon_path;

  const vs_horizontal_card(
      {Key key, this.vs_name, this.vs_value, this.vs_unit, this.vs_icon_path})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(left: 0, top: 10, right: 0, bottom: 10),
        margin: EdgeInsets.only(top: 5),
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
              width: 55,
              child: Image.asset(vs_icon_path),
            ),
            SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    vs_name,
                    style: TextStyle(color: AppColors.textColor, fontSize: 17),
                  ),
//                              SizedBox(height: 4),
                  Row(
                    children: <Widget>[
                      Text(
                        '${vs_value}', //widget.doc_bp
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                        ),
                      ),
                      SizedBox(width: 3),
                      Text(
                        vs_unit,
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
    );
  }
}

class vsLive_item_bp extends StatelessWidget {
  final String title;
  final String valueToShow;
  final String valueUnit;
  final String iconPath;
  final Function press;
  final double maxWidth;
  final bool isAbnormal;
  final String bp_MAP_value;

  const vsLive_item_bp({
    Key key,
    this.title,
    this.valueToShow,
    this.valueUnit,
    this.iconPath,
    this.press,
    this.maxWidth = 0,
    this.isAbnormal = false,
    this.bp_MAP_value = '100',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: press,
          child: Container(
            width: maxWidth == 0 ? constraints.maxWidth / 3 - 20 : maxWidth,
            height: constraints.maxWidth / 2 - 50,
            // Here constraints.maxWidth provide us the available width for the widget
            decoration: BoxDecoration(
              color: !isAbnormal ? Colors.white : Color(0xFFFFD2D2),
              borderRadius: BorderRadius.circular(10),
              border: !isAbnormal
                  ? Border.all(width: 0, color: Color(0xFFFFFFFF))
                  : Border.all(width: 2.0, color: Color(0xFFE01A1A)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(1, 2), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Row(
                    children: <Widget>[
                      // wrapped within an expanded widget to allow for small density device
                      Container(
                        alignment: Alignment.topLeft,
                        height: 40,
//                            width: 30,
                        child: Image.asset(iconPath),
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: AppColors.textColor,
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              // bottom: 10,
                              right: 10,
                              left: 5),
                          child: Text(
                            '($bp_MAP_value)',
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainColor,
                                fontSize: 22),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, bottom: 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Text(
                          '$valueToShow',
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainColor),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                            right: 10,
                          ),
                          child: Text(
                            '$valueUnit',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainColor,
                                fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

navigateTo(BuildContext context, var pageToNavigate) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => pageToNavigate),
  );
  // LoginPage()AbnormalVsBoard
}
