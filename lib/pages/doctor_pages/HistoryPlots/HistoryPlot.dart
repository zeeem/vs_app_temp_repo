import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:scidart/numdart.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';
import 'package:vital_signs_ui_template/pages/doctor_pages/HistoryPlots/plot_details.dart';

import '../docPatientListPage.dart';
import '../doctor_parient_history.dart';
import '../doctor_profile_page.dart';

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

  List<dynamic> dataToPlot = [];
  List<dynamic> demo_chart = [];
  double maxX_range = 2000;
  double _currentSliderValue = 30;

  int dataIndex_to_show = 0; // 0=hr, 1=rr, 2=spo2, 3=temp

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
  int _touchedIndex = 0;
  double _touchedSpotValue = 0.0;

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
    dataToPlot = data;

    switch (widget.expandedTitle) {
      case 'hr':
        hrExpansion = true;
        dataIndex_to_show = 0;
        break;
      case 'rr':
        rrExpansion = true;
        dataIndex_to_show = 1;
        break;
      case 'spo2':
        spo2Expansion = true;
        dataIndex_to_show = 2;
        break;
      case 'temp':
        tempExpansion = true;
        dataIndex_to_show = 3;
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

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  updateRange(int rangeVal) {
    if (rangeVal != -1) {
      rangeVal = rangeVal * 20;
      demo_chart = data.getRange(data.length - rangeVal, data.length).toList();
    } else {
      demo_chart = data;
    }
    setState(() {
      maxX_range = 1.00 * demo_chart.length;
      dataToPlot = demo_chart;
    });
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
                      //   Slider(
                      // value: _currentSliderValue,
                      // min: 0,
                      // max: 180,
                      // divisions: 6,
                      // label: _currentSliderValue.round().toString(),
                      // onChanged: (double value) {
                      //   updateRange(value.toInt());
                      //   setState(() {
                      //     _currentSliderValue = value;
                      //   });
                      // }
                      //   ),

                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new SizedBox(
                            width: 60,
                            height: 28,
                            child: ButtonTheme(
                              minWidth: 88.0,
                              height: 36.0,
                              buttonColor: Colors.white,
                              hoverColor: Colors.lightBlueAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: BorderSide(color: Colors.blue)),
                              child: RaisedButton(
                                child: new Text("30m",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue.withOpacity(0.6))),
                                onPressed: () => {
                                  updateRange(30.toInt()),
                                  setState(() {
                                    _currentSliderValue = 30;
                                  }),
                                },
                              ),
                            ),
                          ),
                          new SizedBox(
                            width: 60,
                            height: 28,
                            child: ButtonTheme(
                              minWidth: 88.0,
                              height: 36.0,
                              buttonColor: Colors.white,
                              hoverColor: Colors.lightBlueAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: BorderSide(color: Colors.blue)),
                              child: RaisedButton(
                                child: new Text("1h",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue.withOpacity(0.6))),
                                onPressed: () => {
                                  updateRange(60.toInt()),
                                  setState(() {
                                    _currentSliderValue = 30;
                                  }),
                                },
                              ),
                            ),
                          ),
                          new SizedBox(
                            width: 60,
                            height: 28,
                            child: ButtonTheme(
                              minWidth: 88.0,
                              height: 36.0,
                              buttonColor: Colors.white,
                              hoverColor: Colors.lightBlueAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: BorderSide(color: Colors.blue)),
                              child: RaisedButton(
                                child: new Text("3h",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue.withOpacity(0.6))),
                                onPressed: () => {
                                  updateRange(180.toInt()),
                                  setState(() {
                                    _currentSliderValue = 30;
                                  }),
                                },
                              ),
                            ),
                          ),
                          new SizedBox(
                            width: 65,
                            height: 28,
                            child: ButtonTheme(
                              minWidth: 88.0,
                              height: 36.0,
                              buttonColor: Colors.white,
                              hoverColor: Colors.lightBlueAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: BorderSide(color: Colors.blue)),
                              child: RaisedButton(
                                child: new Text("All",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue.withOpacity(0.6))),
                                onPressed: () => {
                                  updateRange(-1.toInt()),
                                  setState(() {
                                    _currentSliderValue = 30;
                                  }),
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      LineChart(
                        LineChartData(
                          extraLinesData: ExtraLinesData(horizontalLines: [
                            HorizontalLine(
                              y: 8000,
                              color: Colors.redAccent,
                            )
                          ]),
                          minX: 0,
                          maxX: maxX_range,
                          minY: 30,
                          maxY: 200,
                          titlesData: FlTitlesData(
                            bottomTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 6,
                                getTitles: (value) {
                                  switch (value.toInt()) {
                                    case 0:
                                      return '0';
                                    case 600:
                                      return '30m';
                                    case 1200:
                                      return '1h';
                                    case 1800:
                                      return '3h';
                                    case 2400:
                                      return '4h';
                                    default:
                                      return '';
                                  }
                                }),
                            leftTitles: SideTitles(
                              showTitles: true,
                              getTitles: (value) {
                                switch (value.toInt()) {
                                  case 50:
                                    return '50';
                                  case 75:
                                    return '75';
                                  case 100:
                                    return '100';
                                  case 125:
                                    return '125';
                                  case 150:
                                    return '150';
                                  default:
                                    return '';
                                }
                              },
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                          lineBarsData: [
                            //loadAsset(),
                            LineChartBarData(
                              spots: generateSpots(),
                              isCurved: true,
                              colors: gradientColors,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(show: false),
                              //barWidth: 1,
                              belowBarData: BarAreaData(
                                  show: true,
                                  colors: gradientColors
                                      .map((color) => color.withOpacity(0.3))
                                      .toList()),
                            ),
                          ],
                          axisTitleData: FlAxisTitleData(
                            bottomTitle: AxisTitle(
                                showTitle: true, titleText: '', margin: 5),
                            leftTitle: AxisTitle(
                                showTitle: true, titleText: '', margin: 0),
                          ),
                          lineTouchData: LineTouchData(getTouchedSpotIndicator:
                              (LineChartBarData barData,
                                  List<int> spotIndexes) {
                            return spotIndexes.map((spotIndex) {
                              final FlSpot spot = barData.spots[spotIndex];

                              _touchedIndex = spotIndex;
                              _touchedSpotValue = spot
                                  .x; //double (getting the x value or y value)

                              // if (spot.x == 0 || spot.x == 30 || spot.x == 29) {
                              //   return null;
                              // }
                            }).toList();
                          }, touchCallback: (LineTouchResponse touchResponse) {
                            if (touchResponse.touchInput is FlPanEnd ||
                                touchResponse.touchInput is FlLongPressEnd) {
                              //goto next page for details
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlotDetails(
                                    touchedIndex: _touchedIndex,
                                    touchedScale: 'hr',
                                  ),
                                ),
                              );
                              setState(() {
                                print('touched index---> $_touchedIndex');
                              });
                            } else {
                              print('wait');
                            }
                          }),
                        ),
                      ),
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
                              spots: generateSpots(),
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
                              spots: generateSpots(),
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
                          minY: 30,
                          maxY: 40,
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                          lineBarsData: [
                            //loadAsset(),
                            LineChartBarData(
                              spots: generateSpots(),
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

  List<FlSpot> generateSpots() {
    List<FlSpot> spots = dataToPlot.asMap().entries.map((e) {
      double y = double.tryParse(e.value[dataIndex_to_show].toString());
      return FlSpot(e.key.toDouble(), y);
    }).toList();

    return spots;
  }
}
