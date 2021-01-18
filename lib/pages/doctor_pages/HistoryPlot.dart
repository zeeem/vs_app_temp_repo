import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'dart:async' show Future;

import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';

import 'docPatientListPage.dart';
import 'doctor_parient_history.dart';
import 'doctor_profile_page.dart';

class HistoryPlot extends StatefulWidget {
  final String expandedTitle;
  final List<dynamic> data;

  const HistoryPlot({Key key, this.data, this.expandedTitle}) : super(key: key);

  @override
  _HistoryPlotState createState() => _HistoryPlotState();
}

class _HistoryPlotState extends State<HistoryPlot> {
  List<dynamic> data = [];
  int xMax;
  bool m = false;
  double x;
  bool isExpanded = false;
  // loadAsset() async {
  //   final myData = await rootBundle.loadString(
  //       "assets/csv/mcgill_ble_rawdata_2021-01-04_142115.986889.csv");
  //
  //   //print(myData);
  //   List<dynamic> csvTable = CsvToListConverter().convert(myData);
  //
  //   print(csvTable[0].last);
  //
  //   xMax = data.length;
  //   setState(() {
  //     data = csvTable;
  //   });
  // }

  int _selectedIndex = 0;

  bool hrExpansion, rrExpansion, spo2Expansion, tempExpansion;

  void _onItemTapped(int index) {
    _selectedIndex = index;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => docPatientListPage(selectedIndex: index),
      ),
    );
  }

  @override
  void initState() {
    data = widget.data;
    xMax = data.length;

    switch (widget.expandedTitle) {
      case 'hr':
        hrExpansion = true;
        break;
      case 'rr':
        rrExpansion = true;
        break;
      case 'spo2':
        spo2Expansion = true;
        break;
      case 'temp':
        tempExpansion = true;
        break;

      default:
        hrExpansion = false;
        rrExpansion = false;
        spo2Expansion = false;
        tempExpansion = false;
    }

    // TODO: implement initState
    super.initState();
    // loadAsset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: CustomAppBar(
        height: 130, //no use of this fixed height
        turnOffBackButton: true,
        turnOffSettingsButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white70.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ExpansionTile(
                initiallyExpanded: hrExpansion ?? false,
                title: Text("Heart Rate",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            hrExpansion ? FontWeight.bold : FontWeight.normal)),
                leading: new Tab(
                    icon: new Image.asset("assets/icons/hr_icon.png",
                        width: 32, height: 32)),
                onExpansionChanged: ((newState) {
                  if (newState)
                    setState(() {
                      trailing:
                      Icon(Icons.keyboard_arrow_right);
                      hrExpansion = true;
                    });
                  else
                    setState(() {
                      trailing:
                      Icon(Icons.keyboard_arrow_down);
                      hrExpansion = false;
                    });
                }),
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: 2000,
                          minY: 3000,
                          maxY: 12000,
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                          lineBarsData: [
                            //loadAsset(),
                            LineChartBarData(
                              spots: test(),
                              colors: [Colors.orange],
                              dotData: FlDotData(show: false),
                              barWidth: 1,
                              belowBarData: BarAreaData(show: true, colors: [
                                Colors.orangeAccent.withOpacity(.5)
                              ]),
                            ),
                          ],
                          axisTitleData: FlAxisTitleData(
                            bottomTitle: AxisTitle(
                                showTitle: true, titleText: 'Time', margin: 10),
                            leftTitle: AxisTitle(
                                showTitle: true,
                                titleText: 'PPG Signals',
                                margin: 10),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                // image: DecorationImage(
                //       image: new NetworkImage("https://png.pngtree.com/element_our/sm/20180516/sm_5afc4ae79bf8f.jpg"),
                //       alignment: Alignment.topLeft,
                //
                // ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white70.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ExpansionTile(
                initiallyExpanded: spo2Expansion ?? false,
                title:
                    Text("Oxygen Saturation", style: TextStyle(fontSize: 20)),
                leading: new Tab(
                    icon: new Image.asset("assets/icons/spo2_icon.png",
                        width: 32, height: 32)),
                onExpansionChanged: ((newState) {
                  if (newState)
                    setState(() {
                      trailing:
                      Icon(Icons.keyboard_arrow_right);
                    });
                  else
                    setState(() {
                      trailing:
                      Icon(Icons.keyboard_arrow_down);
                    });
                }),
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: 2000,
                          minY: 3000,
                          maxY: 12000,
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                          lineBarsData: [
                            //loadAsset(),
                            LineChartBarData(
                              spots: test(),
                              colors: [Colors.orange],
                              dotData: FlDotData(show: false),
                              barWidth: 1,
                              belowBarData: BarAreaData(show: true, colors: [
                                Colors.orangeAccent.withOpacity(.5)
                              ]),
                            ),
                          ],
                          axisTitleData: FlAxisTitleData(
                            bottomTitle: AxisTitle(
                                showTitle: true, titleText: 'Time', margin: 10),
                            leftTitle: AxisTitle(
                                showTitle: true,
                                titleText: 'PPG Signals',
                                margin: 10),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white70.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ExpansionTile(
                initiallyExpanded: rrExpansion ?? false,
                title: Text("Respiratory Rate", style: TextStyle(fontSize: 20)),
                leading: new Tab(
                    icon: new Image.asset("assets/icons/rr_icon.png",
                        width: 32, height: 32)),
                onExpansionChanged: ((newState) {
                  if (newState)
                    setState(() {
                      trailing:
                      Icon(Icons.keyboard_arrow_right);
                    });
                  else
                    setState(() {
                      trailing:
                      Icon(Icons.keyboard_arrow_down);
                    });
                }),
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: 2000,
                          minY: 3000,
                          maxY: 12000,
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                          lineBarsData: [
                            //loadAsset(),
                            LineChartBarData(
                              spots: test(),
                              colors: [Colors.orange],
                              dotData: FlDotData(show: false),
                              barWidth: 1,
                              belowBarData: BarAreaData(show: true, colors: [
                                Colors.orangeAccent.withOpacity(.5)
                              ]),
                            ),
                          ],
                          axisTitleData: FlAxisTitleData(
                            bottomTitle: AxisTitle(
                                showTitle: true, titleText: 'Time', margin: 10),
                            leftTitle: AxisTitle(
                                showTitle: true,
                                titleText: 'PPG Signals',
                                margin: 10),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white70.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ExpansionTile(
                initiallyExpanded: tempExpansion ?? false,
                title: Text("Temperature", style: TextStyle(fontSize: 20)),
                leading: new Tab(
                    icon: new Image.asset("assets/icons/temp_icon.png",
                        width: 32, height: 32)),
                onExpansionChanged: ((newState) {
                  if (newState)
                    setState(() {
                      trailing:
                      Icon(Icons.keyboard_arrow_right);
                    });
                  else
                    setState(() {
                      trailing:
                      Icon(Icons.keyboard_arrow_down);
                    });
                }),
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: 2000,
                          minY: 3000,
                          maxY: 12000,
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                          lineBarsData: [
                            //loadAsset(),
                            LineChartBarData(
                              spots: test(),
                              colors: [Colors.orange],
                              dotData: FlDotData(show: false),
                              barWidth: 1,
                              belowBarData: BarAreaData(show: true, colors: [
                                Colors.orangeAccent.withOpacity(.5)
                              ]),
                            ),
                          ],
                          axisTitleData: FlAxisTitleData(
                            bottomTitle: AxisTitle(
                                showTitle: true, titleText: 'Time', margin: 10),
                            leftTitle: AxisTitle(
                                showTitle: true,
                                titleText: 'PPG Signals',
                                margin: 10),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
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
            icon: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.deccolor1,
        onTap: _onItemTapped,
      ),
    );
  }

  List<FlSpot> test() {
    List<FlSpot> spots = data.asMap().entries.map((e) {
      double y = double.tryParse(e.value.last.toString());
      return FlSpot(e.key.toDouble(), y);
    }).toList();

    return spots;
  }
}
