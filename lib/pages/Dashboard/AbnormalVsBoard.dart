import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';
import 'package:vital_signs_ui_template/elements/User.dart';
import 'package:vital_signs_ui_template/pages/Dashboard/vs_item.dart';
import 'package:intl/intl.dart';
import 'package:vital_signs_ui_template/pages/doctor_pages/HistoryPlots/HistoryPlot.dart';
import 'package:vital_signs_ui_template/pages/doctor_pages/HistoryPlots/HistoryPlot_element.dart';
import 'package:vital_signs_ui_template/pages/doctor_pages/docVSPage.dart';

import '../AlertHomePage.dart';
import 'alert_Cards.dart';

bool simulateDoctorBehavior = false;

class AbnormalVsBoard extends StatefulWidget {
  final User clicked_user;
  final int selectedIndexToOpen;
  final String openedHistoryVSType;

  const AbnormalVsBoard(
      {Key key,
      this.clicked_user,
      this.selectedIndexToOpen = 0,
      this.openedHistoryVSType})
      : super(key: key);

  @override
  _AbnormalVsBoardState createState() => _AbnormalVsBoardState();
}

class _AbnormalVsBoardState extends State<AbnormalVsBoard> {
  User _clickUser;
  String _userName;
  List<dynamic> historyData = [];
  int _selectedIndex = 0;
  String _openedHistoryVSType;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (_selectedIndex == 0) {
        print('index 0');
      } else if (_selectedIndex == 1) {
        print('index 1');
      } else if (_selectedIndex == 2) {
        print('index 2');
      }
    });
  }

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
    if (tempStaticVals.historyplot == null) {
      // load assets
      loadAsset();
    } else {
      historyData = tempStaticVals.historyplot;
    }

    if (_clickUser != null) {
      _clickUser = widget.clicked_user;
      _userName = _clickUser.name;
    } else {
      _userName = '';
    }
    _selectedIndex = 0;
    _openedHistoryVSType = widget.openedHistoryVSType;
    _selectedIndex = widget.selectedIndexToOpen;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 120,
        turnOffBackButton: true,
        turnOffSettingsButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  // Container(
                  //   padding: EdgeInsets.fromLTRB(20, 0, 20, 0.0),
                  //   child: Text(
                  //     'Here are your patients\' records',
                  //     style: TextStyle(
                  //         fontSize: 21.0, fontWeight: FontWeight.bold),
                  //     textAlign: TextAlign.left,
                  //   ),
                  // )
                ],
              ),
            ),
            AnimatedSwitcher(
                transitionBuilder: (widget, animation) {
                  return SlideTransition(
                    position:
                        Tween<Offset>(begin: Offset(.5, 0), end: Offset.zero)
                            .animate(animation),
                    child: widget,
                  );
                },
                duration: Duration(milliseconds: 300),
                child: () {
                  switch (_selectedIndex) {
                    case 0:
                      _openedHistoryVSType = null;
                      return doctorVSPage_element();
                    case 1:
                      if (_openedHistoryVSType != null) {
                        return HistoryPlotElement(
                          data: historyData,
                          expandedTitle: _openedHistoryVSType,
                        );
                      } else {
                        return AbnormalVSList(
                          userName: _userName,
                          historyData: historyData,
                        );
                      }
                      break;

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => HistoryPlot(
                    //       data: historyData,
                    //       expandedTitle: 'hr',
                    //     ),
                    //   ),
                    // );
                    // break;
                    case 2:
                      if (simulateDoctorBehavior) {
                        return contactPatientPage(
                          alert_text:
                              "Do you want to call ${_userName.length > 0 ? _userName : 'Jon'}?",
                        );
                      } else {
                        return AlterWindowV2(
                          alert_text: "Your trusted care-network.",
                        );
                      }
                      break;

                    default:
                      return AbnormalVSList(
                        userName: _userName,
                        historyData: historyData,
                      );
                  }
                }()),
            // SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            title: Text('History'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            title: Text(simulateDoctorBehavior ? 'Contact' : 'HELP'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.deccolor1,
        onTap: _onItemTapped,
      ),
    );
  }
}


class AbnormalVSList extends StatefulWidget {
  final String userName;
  final List historyData;

  const AbnormalVSList({Key key, this.userName, this.historyData})
      : super(key: key);

  @override
  _AbnormalVSListState createState() => _AbnormalVSListState();
}

class _AbnormalVSListState extends State<AbnormalVSList> {
  String userName;
  List historyData;
  bool visibilityTag = false;

  @override
  void initState() {
    // TODO: implement initState
    userName=widget.userName;
    historyData=widget.historyData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // SizedBox(
          //   height: 20,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              visibilityTag?
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Row(
                  children: [
                    Text('Filter by: ', style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8,0,8,0),
                      child: DropdownButton<String>(
                        hint: Text('Recent', style: TextStyle(fontSize: 15),),
                        items: <String>['Recent', 'Older'].map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                    ),
                    DropdownButton<String>(
                      hint: Text('All', style: TextStyle(fontSize: 15),),
                      items: <String>['All', 'HR', 'RR', 'Spo2', 'Temp', 'BP'].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {},
                    )


                  ],
                ),
              ):Container(),
              Container(

                //padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: FlatButton(
                  onPressed: (){
                    setState(() {
                      if(visibilityTag == false)
                      {
                        visibilityTag = true;
                      }
                      else
                      {
                        visibilityTag = false;
                      }
                    });

                  },
                  child:
                      visibilityTag?
                  Text('Filter', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)
                          :Text('Filter', style: TextStyle(fontSize: 15),),
                ),
              ),
              // Container(
              //   padding: EdgeInsets.fromLTRB(20, 0, 0, 0.0),
              //   child: Text(
              //     (userName.length > 0)
              //         ? 'History of $userName'
              //         : "Vital Sign History",
              //     style: TextStyle(
              //         fontSize: 25.0,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.black.withOpacity(.7)),
              //     // textAlign: TextAlign.left,
              //   ),
              // ),
              // Container(
              //   padding: EdgeInsets.fromLTRB(0, 5, 20, 0),
              //   child: Row(
              //     children: [
              //       // Text('Sort By'),
              //       DropdownButton<String>(
              //         icon: Icon(Icons.sort),
              //         isDense: true,
              //         style: TextStyle(fontSize: 10, color: Colors.black),
              //         items: <String>[
              //           'Recent Abnormals',
              //           'Abnormal HR',
              //           'Abnormal RR',
              //           'Abnormal TEMP',
              //           'Abnormal SPO2'
              //         ].map((String value) {
              //           return DropdownMenuItem<String>(
              //             value: value,
              //             child: Text(value),
              //           );
              //         }).toList(),
              //         onChanged: (_) {},
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          // SizedBox(
          //   height: 20,
          // ),
          alert_Card(
            hr_val: 100,
            spo2_alert: true,
            temp_val: 37,
            spo2_val: 89,
            rr_val: 15,
            bp_val: [125, 90],
            time_substract_val: Duration(minutes: 0),
            vs_data: tempStaticVals.historyplot,
          ),
          alert_Card(
            hr_val: 130,
            hr_alert: true,
            temp_val: 37,
            temp_alert: false,
            spo2_val: 94,
            rr_val: 16,
            bp_val: [120, 85],
            time_substract_val: Duration(hours: 5),
            vs_data: tempStaticVals.historyplot,
          ),
          alert_Card(
            hr_val: 78,
            hr_alert: false,
            temp_val: 39.5,
            temp_alert: true,
            spo2_val: 95,
            rr_val: 17,
            bp_val: [130, 98],
            time_substract_val: Duration(hours: 9),
            vs_data: tempStaticVals.historyplot,
          ),
          alert_Card(
            hr_val: 84,
            hr_alert: false,
            temp_val: 38,
            temp_alert: false,
            spo2_val: 94,
            spo2_alert: true,
            rr_val: 15,
            bp_val: [140, 94],
            time_substract_val: Duration(hours: 17),
            vs_data: tempStaticVals.historyplot,
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

class tempStaticVals {
  static List<dynamic> historyplot;

  static loadAsset() async {
    final myData = await rootBundle.loadString("assets/csv/dummy2.csv");

    //print(myData);
    List<dynamic> csvTable = CsvToListConverter().convert(myData);
    print(csvTable[0].last);

    // historyData = csvTable;

    tempStaticVals.historyplot = csvTable;
    // print(historyData);
  }
}
