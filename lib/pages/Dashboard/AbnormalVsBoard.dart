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

import '../AlertHomePage.dart';
import 'alert_Cards.dart';

class AbnormalVsBoard extends StatefulWidget {
  final User clicked_user;
  final int selectedIndexToOpen;

  const AbnormalVsBoard(
      {Key key, this.clicked_user, this.selectedIndexToOpen = 0})
      : super(key: key);

  @override
  _AbnormalVsBoardState createState() => _AbnormalVsBoardState();
}

class _AbnormalVsBoardState extends State<AbnormalVsBoard> {
  User _clickUser;
  String _userName;
  List<dynamic> historyData = [];
  int _selectedIndex = 0;

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
                      return AbnormalVSList(
                        userName: _userName,
                        historyData: historyData,
                      );
                    case 1:
                      return HistoryPlotElement(
                        data: historyData,
                        expandedTitle: 'hr',
                      );
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
                      return AlterWindowV2(
                        alert_text: "Your trusted care-network.",
                      );

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
        items: const <BottomNavigationBarItem>[
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
            title: Text('HELP'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.deccolor1,
        onTap: _onItemTapped,
      ),
    );
  }
}

class AbnormalVSList extends StatelessWidget {
  final String userName;
  final List historyData;

  const AbnormalVSList({Key key, this.userName, this.historyData})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0.0),
                child: Text(
                  (userName.length > 0)
                      ? 'History of $userName'
                      : "Vital Signs History",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(.7)),
                  // textAlign: TextAlign.left,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 20, 0),
                child: Row(
                  children: [
                    // Text('Sort By'),
                    DropdownButton<String>(
                      icon: Icon(Icons.sort),
                      isDense: true,
                      style: TextStyle(fontSize: 10, color: Colors.black),
                      items: <String>[
                        'Recent Abnormals',
                        'Abnormal HR',
                        'Abnormal RR',
                        'Abnormal TEMP',
                        'Abnormal SPO2'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {},
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          alert_Card(
            hr_val: 120,
            hr_alert: true,
            temp_val: 37,
            spo2_val: 98,
            rr_val: 15,
            bp_val: [125, 90],
            time_substract_val: Duration(minutes: 0),
            vs_data: tempStaticVals.historyplot,
          ),
          alert_Card(
            hr_val: 80,
            hr_alert: false,
            temp_val: 39,
            temp_alert: true,
            spo2_val: 99,
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
            spo2_val: 96,
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
  static List historyplot;
}
