import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'dart:async' show Future;
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:scidart/numdart.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';
import 'package:vital_signs_ui_template/pages/doctor_pages/HistoryPlots/plot_details.dart';
import 'PlotDataProcessing.dart';
import 'package:intl/intl.dart';

import '../docPatientListPage.dart';
import '../doctor_parient_history.dart';
import '../doctor_profile_page.dart';

class HistoryPlotStickyElement extends StatefulWidget {
  final String expandedTitle;
  final List<dynamic> data;

  const HistoryPlotStickyElement({Key key, this.expandedTitle, this.data})
      : super(key: key);

  @override
  _HistoryPlotStickyElementState createState() =>
      _HistoryPlotStickyElementState();
}

class _HistoryPlotStickyElementState extends State<HistoryPlotStickyElement> {
  List<dynamic> data = [];
  int xMax;
  bool m = false;
  double x;
  bool isExpanded = false;
  bool isRangeOn1HourGraph = false;
  bool isStdDeviationOn1HourGraph = false;
  bool isMinMaxOn1HourGraph = false;
  bool isRangeOn24HoursGraph = true;
  bool isStdDeviationOn24HoursGraph = false;
  bool isMinMaxOn24HoursGraph = true;
  bool isRangeOn3WeeksGraph = false;
  bool isMinMaxOn3WeeksGraph = false;

  Random random = new Random();
  int randomNumber7 = 0, randomNumber2 = 0;

  List<dynamic> dataToPlot_hr = [];
  List<dynamic> hourlyDataToPlot_hr = [];
  List<dynamic> demo_chart_hr = [];
  List<dynamic> whole_day_data_hr = [];
  double maxX_range_hr = 60;
  double maxX_range_hourly_hr = 24;

  double _currentSliderValue = 30;

  List<dynamic> dataToPlot_temp = [];
  List<dynamic> hourlyDataToPlot_temp = [];
  List<dynamic> demo_chart_temp = [];
  List<dynamic> whole_day_data_temp = [];
  double maxX_range_temp = 60;
  double maxX_range_hourly_temp = 24;

  List<dynamic> dataToPlot_spo2 = [];
  List<dynamic> hourlyDataToPlot_spo2 = [];
  List<dynamic> demo_chart_spo2 = [];
  List<dynamic> whole_day_data_spo2 = [];
  double maxX_range_spo2 = 60;
  double maxX_range_hourly_spo2 = 24;

  int dataIndex_to_show =
      0; // 0=hr, 1=rr, 2=spo2, 3=temp  - might need to change (min, max, median)

  int _selectedIndex = 0;
  int _touchedIndex = 0;
  double _touchedSpotValue = 0.0;

  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex;

  List<double> bardata = [];

  bool hrExpansion = false,
      rrExpansion = false,
      spo2Expansion = false,
      tempExpansion = false;

  void _onItemTapped(int index) {
    _selectedIndex = index;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => docPatientListPage(selectedIndex: index),
      ),
    );
  }

  void initial_plot(List data) {
    int length = data.length;
    List sub_data = data.sublist(length - 1200, length);
    dataToPlot_hr = processRange(sub_data, 20, "hr");
    dataIndex_to_show = 1; // 0 = min, 1 = average, 2 = max
    maxX_range_hr = dataToPlot_hr.length * 1.0;
  }

  void initial_plot_temp(List data) {
    int length = data.length;
    List sub_data = data.sublist(length - 1200, length);
    dataToPlot_temp = processRange(sub_data, 20, "temp");
    dataIndex_to_show = 1; // 0 = min, 1 = average, 2 = max
    maxX_range_temp = dataToPlot_temp.length * 1.0;
  }

  void initial_plot_spo2(List data) {
    int length = data.length;
    List sub_data = data.sublist(length - 1200, length);
    dataToPlot_spo2 = processRange(sub_data, 20, "spo2");
    dataIndex_to_show = 1; // 0 = min, 1 = average, 2 = max
    maxX_range_spo2 = dataToPlot_spo2.length * 1.0;
  }

  void initial_hourly_plot_hr(List data) {
    int length = data.length;
    List sub_data = data.sublist(length - 28800, length);
    whole_day_data_hr = sub_data;
    hourlyDataToPlot_hr = processRange(sub_data, 1200, "hr", 'median');
    //dataIndex_to_show = 1;   // 0 = min, 1 = average, 2 = max
    maxX_range_hourly_hr = hourlyDataToPlot_hr.length * 1.0;
  }

  void initial_hourly_plot_sp02(List data) {
    int length = data.length;
    List sub_data = data.sublist(length - 28800, length);
    whole_day_data_spo2 = sub_data;
    hourlyDataToPlot_spo2 = processRange(sub_data, 1200, "spo2", 'median');
    //dataIndex_to_show = 1;   // 0 = min, 1 = average, 2 = max
    maxX_range_hourly_spo2 = hourlyDataToPlot_spo2.length * 1.0;
  }

  String getTimes(int timeToAdd, String typeOfTime) {
    final DateTime now = DateTime.now();
    //String formattedDate = DateFormat().add_jm().format(now);
    //print(formattedDate);

    switch (typeOfTime) {
      case 'min':
        DateTime add15Minutes = now.subtract(new Duration(minutes: timeToAdd));
        String formattedDate = DateFormat().add_jm().format(add15Minutes);
        return formattedDate;
      case 'hour':
        DateTime add1Hour = now.subtract(new Duration(hours: timeToAdd));
        String formattedDate = DateFormat().add_jm().format(add1Hour);
        return formattedDate;
      case 'day':
        DateTime add1Day = now.subtract(new Duration(days: timeToAdd));
        String formattedDate = DateFormat().add_Md().format(add1Day);
        return formattedDate;
      default:
        DateTime add15Minutes = now.subtract(new Duration(minutes: timeToAdd));
        String formattedDate = DateFormat().add_jm().format(add15Minutes);
        return formattedDate;
    }
  }

  @override
  void initState() {
    data = widget.data;
    xMax = data.length;
    //dataToPlot = data;
    initial_plot(data);
    initial_plot_temp(
        data); //Initial function to show last 1 hour data (1 min average)
    initial_hourly_plot_hr(data); //Initial hourly data
    initial_plot_spo2(data);
    initial_hourly_plot_sp02(data);

    // random ints
    randomNumber7 = random.nextInt(7);
    randomNumber2 = random.nextInt(3);

    print(dataToPlot_hr);

    switch (widget.expandedTitle) {
      case 'hr':
        hrExpansion = true;
        // dataIndex_to_show = 0;
        break;
      case 'rr':
        rrExpansion = true;
        // dataIndex_to_show = 1;
        break;
      case 'spo2':
        spo2Expansion = true;
        // dataIndex_to_show = 2;
        break;
      case 'temp':
        tempExpansion = true;
        // dataIndex_to_show = 3;
        break;

      default:
        hrExpansion = false;
        rrExpansion = false;
        spo2Expansion = false;
        tempExpansion = false;
    }

    final barGroup1 = makeGroupData(0, 6, 10, 15);
    final barGroup2 = makeGroupData(1, 8, 11, 17);
    final barGroup3 = makeGroupData(2, 6, 12, 19);
    //final barGroup4 = makeGroupData(3, 20, 16, 11);
    // final barGroup5 = makeGroupData(4, 17, 6, 11);
    // final barGroup6 = makeGroupData(5, 19, 1.5, 13);
    // final barGroup7 = makeGroupData(6, 10, 1.5, 7);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      //barGroup4,
      // barGroup5,
      // barGroup6,
      // barGroup7,
    ];

    //print(demo.length);
    rawBarGroups = items;

    showingBarGroups = rawBarGroups;

    // TODO: implement initState
    super.initState();
    // loadAsset();
    print(randomNumber7);
  }

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    //const Color(0xff02d39a),
  ];

  updateRange(int rangeVal) {
    if (rangeVal != -1) {
      rangeVal = rangeVal * 20;
      demo_chart_hr =
          data.getRange(data.length - rangeVal, data.length).toList();
    } else {
      demo_chart_hr = data;
    }
    setState(() {
      maxX_range_hr = 1.00 * demo_chart_hr.length;
      dataToPlot_hr = demo_chart_hr;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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

                    // ButtonBar(
                    //   alignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     new SizedBox(
                    //       width: 60,
                    //       height: 28,
                    //       child: ButtonTheme(
                    //         minWidth: 88.0,
                    //         height: 36.0,
                    //         buttonColor: Colors.white,
                    //         hoverColor: Colors.lightBlueAccent,
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(30),
                    //             side: BorderSide(color: Colors.blue)),
                    //         child: RaisedButton(
                    //           child: new Text("30m",
                    //               style: TextStyle(
                    //                   fontSize: 12,
                    //                   color: Colors.blue.withOpacity(0.6))),
                    //           onPressed: () => {
                    //             updateRange(30.toInt()),
                    //             setState(() {
                    //               _currentSliderValue = 30;
                    //             }),
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //     new SizedBox(
                    //       width: 60,
                    //       height: 28,
                    //       child: ButtonTheme(
                    //         minWidth: 88.0,
                    //         height: 36.0,
                    //         buttonColor: Colors.white,
                    //         hoverColor: Colors.lightBlueAccent,
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(30),
                    //             side: BorderSide(color: Colors.blue)),
                    //         child: RaisedButton(
                    //           child: new Text("1h",
                    //               style: TextStyle(
                    //                   fontSize: 12,
                    //                   color: Colors.blue.withOpacity(0.6))),
                    //           onPressed: () => {
                    //             updateRange(60.toInt()),
                    //             setState(() {
                    //               _currentSliderValue = 30;
                    //             }),
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //     new SizedBox(
                    //       width: 60,
                    //       height: 28,
                    //       child: ButtonTheme(
                    //         minWidth: 88.0,
                    //         height: 36.0,
                    //         buttonColor: Colors.white,
                    //         hoverColor: Colors.lightBlueAccent,
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(30),
                    //             side: BorderSide(color: Colors.blue)),
                    //         child: RaisedButton(
                    //           child: new Text("3h",
                    //               style: TextStyle(
                    //                   fontSize: 12,
                    //                   color: Colors.blue.withOpacity(0.6))),
                    //           onPressed: () => {
                    //             updateRange(180.toInt()),
                    //             setState(() {
                    //               _currentSliderValue = 30;
                    //             }),
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //     new SizedBox(
                    //       width: 65,
                    //       height: 28,
                    //       child: ButtonTheme(
                    //         minWidth: 88.0,
                    //         height: 36.0,
                    //         buttonColor: Colors.white,
                    //         hoverColor: Colors.lightBlueAccent,
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(30),
                    //             side: BorderSide(color: Colors.blue)),
                    //         child: RaisedButton(
                    //           child: new Text("All",
                    //               style: TextStyle(
                    //                   fontSize: 12,
                    //                   color: Colors.blue.withOpacity(0.6))),
                    //           onPressed: () => {
                    //             updateRange(-1.toInt()),
                    //             setState(() {
                    //               _currentSliderValue = 30;
                    //             }),
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    Container(
                      width: 335,
                      //height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[100],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Center(
                              child: Text("Last 1 Hour",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor)),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 25,
                                child: FlatButton(
                                    onPressed: () {
                                      if (isRangeOn1HourGraph) {
                                        setState(() {
                                          isRangeOn1HourGraph = false;
                                        });
                                      } else {
                                        setState(() {
                                          isRangeOn1HourGraph = true;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "---- ",
                                            style: TextStyle(
                                                color: isRangeOn1HourGraph
                                                    ? Colors.redAccent
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "Range",
                                            style: TextStyle(
                                                color: AppColors.textColor),
                                          ),
                                          Icon(
                                            Icons.fiber_manual_record_rounded,
                                            color: isRangeOn1HourGraph
                                                ? Colors.green
                                                : Colors.grey,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 25,
                                child: FlatButton(
                                    onPressed: () {
                                      if (isStdDeviationOn1HourGraph) {
                                        setState(() {
                                          isStdDeviationOn1HourGraph = false;
                                        });
                                      } else {
                                        setState(() {
                                          isStdDeviationOn1HourGraph = true;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "---- ",
                                            style: TextStyle(
                                                color:
                                                    isStdDeviationOn1HourGraph
                                                        ? Colors.black54
                                                        : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "Standard Deviation",
                                            style: TextStyle(
                                                color: AppColors.textColor),
                                          ),
                                          Icon(
                                            Icons.fiber_manual_record_rounded,
                                            color: isStdDeviationOn1HourGraph
                                                ? Colors.green
                                                : Colors.grey,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          LineChart(
                            LineChartData(
                              extraLinesData: isRangeOn1HourGraph
                                  ? ExtraLinesData(horizontalLines: [
                                      HorizontalLine(
                                        //y: isSwitched? 75:0,
                                        y: 75,
                                        color: Colors.redAccent,
                                        strokeWidth: 1,
                                      ),
                                      HorizontalLine(
                                        //y: isSwitched? 75:0,
                                        y: 85,
                                        color: Colors.redAccent,
                                        strokeWidth: 1,
                                      ),
                                    ])
                                  : ExtraLinesData(),
                              minX: 0,
                              maxX: maxX_range_hr,
                              minY: 30,
                              maxY: 150,
                              titlesData: FlTitlesData(
                                bottomTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 6,
                                    getTitles: (value) {
                                      if (value.toInt() % 15 == 0) {
                                        return getTimes(value.toInt(), 'min');
                                      } else {
                                        return '';
                                      }
                                      // switch (value.toInt()) {
                                      //   case 0:
                                      //     return '1m';
                                      //   case 15:
                                      //     return '15m';
                                      //   case 30:
                                      //     return '30m';
                                      //   case 45:
                                      //     return '45m';
                                      //   case 60:
                                      //     return '1h';
                                      //   default:
                                      //     return '';
                                      // }
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
                                  spots: generateSpots(dataToPlot_hr,
                                      dataIndex_to_show), // mean data, index 1 = avg
                                  isCurved: true,
                                  colors: gradientColors,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                  //barWidth: 1,
                                  belowBarData: BarAreaData(
                                      show: true,
                                      colors: gradientColors
                                          .map((color) =>
                                              color.withOpacity(0.15))
                                          .toList()),
                                ),

                                LineChartBarData(
                                  spots: generateSpots(
                                      dataToPlot_hr, 3), // deviation negative
                                  isCurved: true,
                                  colors: [Colors.black54],
                                  barWidth: 1,
                                  isStrokeCapRound: true,
                                  show:
                                      isStdDeviationOn1HourGraph ? true : false,
                                  dotData: FlDotData(show: false),
                                  //barWidth: 1,
                                ),

                                LineChartBarData(
                                  spots: generateSpots(
                                      dataToPlot_hr, 4), // deviation positive
                                  isCurved: true,
                                  colors: [Colors.black54],
                                  barWidth: 1,
                                  isStrokeCapRound: true,
                                  show:
                                      isStdDeviationOn1HourGraph ? true : false,
                                  dotData: FlDotData(show: false),
                                  //barWidth: 1,
                                ),
                              ],
                              axisTitleData: FlAxisTitleData(
                                bottomTitle: AxisTitle(
                                    showTitle: true, titleText: '', margin: 5),
                                leftTitle: AxisTitle(
                                    showTitle: true, titleText: '', margin: 0),
                              ),
                              // lineTouchData: LineTouchData(getTouchedSpotIndicator:
                              //     (LineChartBarData barData,
                              //         List<int> spotIndexes) {
                              //   return spotIndexes.map((spotIndex) {
                              //     final FlSpot spot = barData.spots[spotIndex];
                              //
                              //     _touchedIndex = spotIndex;
                              //     _touchedSpotValue = spot
                              //         .x; //double (getting the x value or y value)
                              //
                              //     // if (spot.x == 0 || spot.x == 30 || spot.x == 29) {
                              //     //   return null;
                              //     // }
                              //   }).toList();
                              // }, touchCallback: (LineTouchResponse touchResponse) {
                              //   if (touchResponse.touchInput is FlPanEnd ||
                              //       touchResponse.touchInput is FlLongPressEnd) {
                              //     //goto next page for details
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => PlotDetails(
                              //           touchedIndex: _touchedIndex,
                              //           touchedScale: 'hr',
                              //         ),
                              //       ),
                              //     );
                              //     setState(() {
                              //       print('touched index---> $_touchedIndex');
                              //     });
                              //   } else {
                              //     print('wait');
                              //   }
                              // }),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Container(
                      width: 335,
                      //height: 300,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[100],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Center(
                              child: Text("Last 24 Hours",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor)),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 25,
                                child: FlatButton(
                                    onPressed: () {
                                      if (isRangeOn24HoursGraph) {
                                        setState(() {
                                          isRangeOn24HoursGraph = false;
                                        });
                                      } else {
                                        setState(() {
                                          isRangeOn24HoursGraph = true;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "---- ",
                                            style: TextStyle(
                                                color: isRangeOn24HoursGraph
                                                    ? Colors.green
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "Range",
                                            style: TextStyle(
                                                color: AppColors.textColor),
                                          ),
                                          Icon(
                                            Icons.fiber_manual_record_rounded,
                                            color: isRangeOn24HoursGraph
                                                ? Colors.green
                                                : Colors.grey,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 25,
                                child: FlatButton(
                                    onPressed: () {
                                      if (isStdDeviationOn24HoursGraph) {
                                        setState(() {
                                          isStdDeviationOn24HoursGraph = false;
                                        });
                                      } else {
                                        setState(() {
                                          isStdDeviationOn24HoursGraph = true;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "---- ",
                                            style: TextStyle(
                                                color:
                                                    isStdDeviationOn24HoursGraph
                                                        ? Colors.black54
                                                        : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "Standard Deviation",
                                            style: TextStyle(
                                                color: AppColors.textColor),
                                          ),
                                          Icon(
                                            Icons.fiber_manual_record_rounded,
                                            color: isStdDeviationOn24HoursGraph
                                                ? Colors.green
                                                : Colors.grey,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 25,
                                child: FlatButton(
                                    onPressed: () {
                                      if (isMinMaxOn24HoursGraph) {
                                        setState(() {
                                          isMinMaxOn24HoursGraph = false;
                                        });
                                      } else {
                                        setState(() {
                                          isMinMaxOn24HoursGraph = true;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "--",
                                            style: TextStyle(
                                                color: isMinMaxOn24HoursGraph
                                                    ? Colors.orangeAccent
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "-- ",
                                            style: TextStyle(
                                                color: isMinMaxOn24HoursGraph
                                                    ? Colors.yellowAccent
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "Min Max Line",
                                            style: TextStyle(
                                                color: AppColors.textColor),
                                          ),
                                          Icon(
                                            Icons.fiber_manual_record_rounded,
                                            color: isMinMaxOn24HoursGraph
                                                ? Colors.green
                                                : Colors.grey,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          LineChart(
                            LineChartData(
                              extraLinesData: isRangeOn24HoursGraph
                                  ? ExtraLinesData(horizontalLines: [
                                      HorizontalLine(
                                        y: 75,
                                        color: Colors.green,
                                        strokeWidth: 1,
                                      ),
                                      HorizontalLine(
                                        //y: isSwitched? 75:0,
                                        y: 85,
                                        color: Colors.green,
                                        strokeWidth: 1,
                                      ),
                                    ])
                                  : ExtraLinesData(),
                              minX: 0,
                              maxX: maxX_range_hourly_hr,
                              minY: 30,
                              maxY: 150,
                              titlesData: FlTitlesData(
                                bottomTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 6,
                                    getTitles: (value) {
                                      if (value.toInt() % 6 == 0) {
                                        return getTimes(value.toInt(), 'hour');
                                      } else {
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
                                      default:
                                        return '';
                                    }
                                  },
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: FlGridData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: generateHourlySpots(1),
                                  isCurved: true,
                                  colors: gradientColors,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                  //barWidth: 1,
                                  belowBarData: BarAreaData(
                                      show: true,
                                      colors: gradientColors
                                          .map((color) =>
                                              color.withOpacity(0.15))
                                          .toList()),
                                ),
                                LineChartBarData(
                                  spots: generateHourlySpots(0),
                                  isCurved: true,
                                  colors: [Colors.yellowAccent],
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                  show: isMinMaxOn24HoursGraph ? true : false,
                                  //barWidth: 1,
                                ),
                                LineChartBarData(
                                  spots: generateHourlySpots(2),
                                  isCurved: true,
                                  colors: [Colors.deepOrangeAccent],
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                  show: isMinMaxOn24HoursGraph ? true : false,
                                  //barWidth: 1,
                                ),
                                LineChartBarData(
                                  spots: generateHourlySpots(3),
                                  isCurved: true,
                                  colors: [Colors.grey],
                                  barWidth: 1,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                  show: isStdDeviationOn24HoursGraph
                                      ? true
                                      : false,
                                  //barWidth: 1,
                                ),
                                LineChartBarData(
                                  spots: generateHourlySpots(4),
                                  isCurved: true,
                                  colors: [Colors.grey],
                                  barWidth: 1,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                  show: isStdDeviationOn24HoursGraph
                                      ? true
                                      : false,
                                  //barWidth: 1,
                                ),
                              ],
                              axisTitleData: FlAxisTitleData(
                                bottomTitle: AxisTitle(
                                    showTitle: true, titleText: '', margin: 5),
                                leftTitle: AxisTitle(
                                    showTitle: true, titleText: '', margin: 0),
                              ),
                              lineTouchData: LineTouchData(
                                  getTouchedSpotIndicator:
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
                              }, touchCallback:
                                      (LineTouchResponse touchResponse) {
                                if (touchResponse.touchInput is FlPanEnd ||
                                    touchResponse.touchInput
                                        is FlLongPressEnd) {
                                  List data_to_send = processRange(
                                      whole_day_data_hr.sublist(
                                          (_touchedIndex) * 1200,
                                          (_touchedIndex * 1200) + 1200),
                                      20);
                                  //goto next page for details
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlotDetails(
                                        touchedIndex: _touchedIndex,
                                        touchedScale: 'hour', //hour,min,day
                                        data_to_plot: data_to_send,
                                        long_data: data,
                                        touchedVSType: 'hr',
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
                    ),

                    // Container(
                    //   padding: EdgeInsets.all(20),
                    //   child: AspectRatio(
                    //     aspectRatio: 1,
                    //     child: Card(
                    //       elevation: 0,
                    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    //       color: Colors.grey[100],
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(16),
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.stretch,
                    //           mainAxisAlignment: MainAxisAlignment.start,
                    //           mainAxisSize: MainAxisSize.max,
                    //           children: <Widget>[
                    //
                    //             Expanded(
                    //               child: Padding(
                    //                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    //                 child: Column(
                    //                   children: [
                    //                     Container(
                    //                       padding: EdgeInsets.only(bottom: 10),
                    //                       child: Center(
                    //                         child: Text("Last 3 Weeks", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textColor)),
                    //                       ),
                    //                     ),
                    //                     Expanded(
                    //                       child: BarChart(
                    //                         BarChartData(
                    //                           maxY: 20,
                    //                           barTouchData: BarTouchData(
                    //                               touchTooltipData: BarTouchTooltipData(
                    //                                 tooltipBgColor: Colors.grey,
                    //                                 getTooltipItem: (_a, _b, _c, _d) => null,
                    //                               ),
                    //                               touchCallback: (response) {
                    //                                 if (response.spot == null) {
                    //                                   setState(() {
                    //                                     touchedGroupIndex = -1;
                    //                                     showingBarGroups = List.of(rawBarGroups);
                    //                                   });
                    //                                   return;
                    //                                 }
                    //
                    //                                 touchedGroupIndex = response.spot.touchedBarGroupIndex;
                    //
                    //                                 setState(() {
                    //                                   if (response.touchInput is FlLongPressEnd ||
                    //                                       response.touchInput is FlPanEnd) {
                    //                                     touchedGroupIndex = -1;
                    //                                     showingBarGroups = List.of(rawBarGroups);
                    //                                   } else {
                    //                                     showingBarGroups = List.of(rawBarGroups);
                    //                                     if (touchedGroupIndex != -1) {
                    //                                       double sum = 0;
                    //                                       for (BarChartRodData rod
                    //                                       in showingBarGroups[touchedGroupIndex].barRods) {
                    //                                         sum += rod.y;
                    //                                       }
                    //                                       final avg =
                    //                                           sum / showingBarGroups[touchedGroupIndex].barRods.length;
                    //
                    //                                       showingBarGroups[touchedGroupIndex] =
                    //                                           showingBarGroups[touchedGroupIndex].copyWith(
                    //                                             barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                    //                                               return rod.copyWith(y: avg);
                    //                                             }).toList(),
                    //                                           );
                    //                                     }
                    //                                   }
                    //                                 });
                    //                               }),
                    //                           titlesData: FlTitlesData(
                    //                             show: true,
                    //                             bottomTitles: SideTitles(
                    //                               showTitles: true,
                    //                               // getTextStyles: (value) => const TextStyle(
                    //                               //     color: Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14),
                    //                               margin: 20,
                    //                               getTitles: (double value) {
                    //                                 switch (value.toInt()) {
                    //                                   case 0:
                    //                                     return 'Week 1';
                    //                                   case 1:
                    //                                     return 'Week 2';
                    //                                   case 2:
                    //                                     return 'Week 3';
                    //                                   case 3:
                    //                                     return 'Week 4';
                    //                                 // case 4:
                    //                                 //   return 'Fr';
                    //                                 // case 5:
                    //                                 //   return 'St';
                    //                                 // case 6:
                    //                                 //   return 'Sn';
                    //                                   default:
                    //                                     return '';
                    //                                 }
                    //                               },
                    //                             ),
                    //                             leftTitles: SideTitles(
                    //                               showTitles: true,
                    //                               // getTextStyles: (value) => const TextStyle(
                    //                               //     color: Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14),
                    //                               margin: 20,
                    //                               reservedSize: 14,
                    //                               getTitles: (value) {
                    //                                 if (value == 0) {
                    //                                   return '0';
                    //                                 } else if (value == 10) {
                    //                                   return '75';
                    //                                 } else if (value == 19) {
                    //                                   return '100';
                    //                                 } else {
                    //                                   return '';
                    //                                 }
                    //                               },
                    //                             ),
                    //                           ),
                    //                           borderData: FlBorderData(
                    //                             show: false,
                    //                           ),
                    //                           barGroups: showingBarGroups,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //             const SizedBox(
                    //               height: 12,
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //
                    //   ),
                    // ),

                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 335,
                      //height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[100],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Center(
                              child: Text("Last 7 Days Data",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor)),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 25,
                                child: FlatButton(
                                    onPressed: () {
                                      if (isRangeOn3WeeksGraph) {
                                        setState(() {
                                          isRangeOn3WeeksGraph = false;
                                        });
                                      } else {
                                        setState(() {
                                          isRangeOn3WeeksGraph = true;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "---- ",
                                            style: TextStyle(
                                                color: isRangeOn3WeeksGraph
                                                    ? Colors.redAccent
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "Range",
                                            style: TextStyle(
                                                color: AppColors.textColor),
                                          ),
                                          Icon(
                                            Icons.fiber_manual_record_rounded,
                                            color: isRangeOn3WeeksGraph
                                                ? Colors.green
                                                : Colors.grey,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 25,
                                child: FlatButton(
                                    onPressed: () {
                                      if (isMinMaxOn3WeeksGraph) {
                                        setState(() {
                                          isMinMaxOn3WeeksGraph = false;
                                        });
                                      } else {
                                        setState(() {
                                          isMinMaxOn3WeeksGraph = true;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "--",
                                            style: TextStyle(
                                                color: isMinMaxOn3WeeksGraph
                                                    ? Colors.orangeAccent
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "-- ",
                                            style: TextStyle(
                                                color: isMinMaxOn3WeeksGraph
                                                    ? Colors.yellowAccent
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "Min Max Line",
                                            style: TextStyle(
                                                color: AppColors.textColor),
                                          ),
                                          Icon(
                                            Icons.fiber_manual_record_rounded,
                                            color: isMinMaxOn3WeeksGraph
                                                ? Colors.green
                                                : Colors.grey,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          LineChart(
                            LineChartData(
                              extraLinesData: isRangeOn3WeeksGraph
                                  ? ExtraLinesData(horizontalLines: [
                                      HorizontalLine(
                                        //y: isSwitched? 75:0,
                                        y: 75,
                                        color: Colors.redAccent,
                                        strokeWidth: 1,
                                      ),
                                      HorizontalLine(
                                        //y: isSwitched? 75:0,
                                        y: 85,
                                        color: Colors.redAccent,
                                        strokeWidth: 1,
                                      ),
                                    ])
                                  : ExtraLinesData(),
                              minX: 0,
                              maxX: 6,
                              minY: 30,
                              maxY: 150,
                              titlesData: FlTitlesData(
                                bottomTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 6,
                                    getTitles: (value) {
                                      if (value.toInt() % 1 == 0) {
                                        return getTimes(value.toInt(), 'day');
                                      } else {
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
                                  spots: [
                                    FlSpot(0, 75),
                                    FlSpot(1, 85),
                                    FlSpot(2, 81),
                                    FlSpot(3, 75),
                                    FlSpot(4, 85),
                                    FlSpot(5, 81),
                                    FlSpot(6, 81)
                                  ], // mean data, index 1 = avg
                                  isCurved: false,
                                  colors: gradientColors,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: true),
                                  //barWidth: 1,
                                  belowBarData: BarAreaData(
                                      show: true,
                                      colors: gradientColors
                                          .map((color) =>
                                              color.withOpacity(0.15))
                                          .toList()),
                                ),

                                LineChartBarData(
                                  spots: [
                                    FlSpot(0, 95),
                                    FlSpot(1, 110),
                                    FlSpot(2, 99),
                                    FlSpot(3, 95),
                                    FlSpot(4, 110),
                                    FlSpot(5, 99),
                                    FlSpot(6, 110)
                                  ],
                                  isCurved: false,
                                  colors: [Colors.deepOrangeAccent],
                                  barWidth: 2,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                  show: isMinMaxOn3WeeksGraph ? true : false,
                                  //barWidth: 1,
                                ),

                                LineChartBarData(
                                  spots: [
                                    FlSpot(0, 70),
                                    FlSpot(1, 77),
                                    FlSpot(2, 69),
                                    FlSpot(3, 65),
                                    FlSpot(4, 77),
                                    FlSpot(5, 69),
                                    FlSpot(6, 69)
                                  ],
                                  isCurved: false,
                                  colors: [Colors.yellowAccent],
                                  barWidth: 2,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                  show: isMinMaxOn3WeeksGraph ? true : false,
                                  //barWidth: 1,
                                ),

                                // LineChartBarData(
                                //   spots: generateSpots(dataToPlot, 3),    // deviation negative
                                //   isCurved: true,
                                //   colors: [Colors.black54],
                                //   barWidth: 1,
                                //   isStrokeCapRound: true,
                                //   show: isStdDeviationOnFirstGraph? true: false,
                                //   dotData: FlDotData(show: false),
                                //   //barWidth: 1,
                                //
                                // ),
                                //
                                // LineChartBarData(
                                //   spots: generateSpots(dataToPlot, 4),    // deviation positive
                                //   isCurved: true,
                                //   colors: [Colors.black54],
                                //   barWidth: 1,
                                //   isStrokeCapRound: true,
                                //   show: isStdDeviationOnFirstGraph? true: false,
                                //   dotData: FlDotData(show: false),
                                //   //barWidth: 1,
                                //
                                // ),
                              ],
                              axisTitleData: FlAxisTitleData(
                                bottomTitle: AxisTitle(
                                    showTitle: true, titleText: '', margin: 5),
                                leftTitle: AxisTitle(
                                    showTitle: true, titleText: '', margin: 0),
                              ),
                            ),
                          ),
                        ],
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
                    Container(
                      width: 335,
                      //height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[100],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Center(
                              child: Text("Last 1 Hour",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor)),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 25,
                                child: FlatButton(
                                    onPressed: () {
                                      if (isRangeOn1HourGraph) {
                                        setState(() {
                                          isRangeOn1HourGraph = false;
                                        });
                                      } else {
                                        setState(() {
                                          isRangeOn1HourGraph = true;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "---- ",
                                            style: TextStyle(
                                                color: isRangeOn1HourGraph
                                                    ? Colors.redAccent
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "Range",
                                            style: TextStyle(
                                                color: AppColors.textColor),
                                          ),
                                          Icon(
                                            Icons.fiber_manual_record_rounded,
                                            color: isRangeOn1HourGraph
                                                ? Colors.green
                                                : Colors.grey,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 25,
                                child: FlatButton(
                                    onPressed: () {
                                      if (isStdDeviationOn1HourGraph) {
                                        setState(() {
                                          isStdDeviationOn1HourGraph = false;
                                        });
                                      } else {
                                        setState(() {
                                          isStdDeviationOn1HourGraph = true;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "---- ",
                                            style: TextStyle(
                                                color:
                                                    isStdDeviationOn1HourGraph
                                                        ? Colors.black54
                                                        : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "Standard Deviation",
                                            style: TextStyle(
                                                color: AppColors.textColor),
                                          ),
                                          Icon(
                                            Icons.fiber_manual_record_rounded,
                                            color: isStdDeviationOn1HourGraph
                                                ? Colors.green
                                                : Colors.grey,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          LineChart(
                            LineChartData(
                              extraLinesData: isRangeOn1HourGraph
                                  ? ExtraLinesData(horizontalLines: [
                                      HorizontalLine(
                                        //y: isSwitched? 75:0,
                                        y: 37.5,
                                        color: Colors.redAccent,
                                        strokeWidth: 1,
                                      ),

                                      // HorizontalLine(
                                      //
                                      //   //y: isSwitched? 75:0,
                                      //   y: 85,
                                      //   color: Colors.redAccent,
                                      //   strokeWidth: 1,
                                      // ),
                                    ])
                                  : ExtraLinesData(),
                              minX: 0,
                              maxX: maxX_range_temp,
                              minY: 30,
                              maxY: 45,
                              titlesData: FlTitlesData(
                                bottomTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 6,
                                    getTitles: (value) {
                                      if (value.toInt() % 15 == 0) {
                                        return getTimes(value.toInt(), 'min');
                                      } else {
                                        return '';
                                      }
                                      // switch (value.toInt()) {
                                      //   case 0:
                                      //     return '1m';
                                      //   case 15:
                                      //     return '15m';
                                      //   case 30:
                                      //     return '30m';
                                      //   case 45:
                                      //     return '45m';
                                      //   case 60:
                                      //     return '1h';
                                      //   default:
                                      //     return '';
                                      // }
                                    }),
                                leftTitles: SideTitles(
                                  showTitles: true,
                                  getTitles: (value) {
                                    if (value.toInt() % 5 == 0) {
                                      return value.toString() + '°C';
                                    } else {
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
                                  spots: generateSpots(dataToPlot_temp,
                                      dataIndex_to_show), // mean data, index 1 = avg
                                  isCurved: true,
                                  colors: gradientColors,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                  //barWidth: 1,
                                  belowBarData: BarAreaData(
                                      show: true,
                                      colors: gradientColors
                                          .map((color) =>
                                              color.withOpacity(0.15))
                                          .toList()),
                                ),

                                LineChartBarData(
                                  spots: generateSpots(
                                      dataToPlot_temp, 3), // deviation negative
                                  isCurved: true,
                                  colors: [Colors.black54],
                                  barWidth: 1,
                                  isStrokeCapRound: true,
                                  show:
                                      isStdDeviationOn1HourGraph ? true : false,
                                  dotData: FlDotData(show: false),
                                  //barWidth: 1,
                                ),

                                LineChartBarData(
                                  spots: generateSpots(
                                      dataToPlot_temp, 4), // deviation positive
                                  isCurved: true,
                                  colors: [Colors.black54],
                                  barWidth: 1,
                                  isStrokeCapRound: true,
                                  show:
                                      isStdDeviationOn1HourGraph ? true : false,
                                  dotData: FlDotData(show: false),
                                  //barWidth: 1,
                                ),
                              ],
                              axisTitleData: FlAxisTitleData(
                                bottomTitle: AxisTitle(
                                    showTitle: true, titleText: '', margin: 5),
                                leftTitle: AxisTitle(
                                    showTitle: true, titleText: '', margin: 0),
                              ),
                              // lineTouchData: LineTouchData(getTouchedSpotIndicator:
                              //     (LineChartBarData barData,
                              //         List<int> spotIndexes) {
                              //   return spotIndexes.map((spotIndex) {
                              //     final FlSpot spot = barData.spots[spotIndex];
                              //
                              //     _touchedIndex = spotIndex;
                              //     _touchedSpotValue = spot
                              //         .x; //double (getting the x value or y value)
                              //
                              //     // if (spot.x == 0 || spot.x == 30 || spot.x == 29) {
                              //     //   return null;
                              //     // }
                              //   }).toList();
                              // }, touchCallback: (LineTouchResponse touchResponse) {
                              //   if (touchResponse.touchInput is FlPanEnd ||
                              //       touchResponse.touchInput is FlLongPressEnd) {
                              //     //goto next page for details
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => PlotDetails(
                              //           touchedIndex: _touchedIndex,
                              //           touchedScale: 'hr',
                              //         ),
                              //       ),
                              //     );
                              //     setState(() {
                              //       print('touched index---> $_touchedIndex');
                              //     });
                              //   } else {
                              //     print('wait');
                              //   }
                              // }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 335,
                      //height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[100],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Center(
                              child: Text("Last 7 Days Data",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor)),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 25,
                                child: FlatButton(
                                    onPressed: () {
                                      if (isRangeOn3WeeksGraph) {
                                        setState(() {
                                          isRangeOn3WeeksGraph = false;
                                        });
                                      } else {
                                        setState(() {
                                          isRangeOn3WeeksGraph = true;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "---- ",
                                            style: TextStyle(
                                                color: isRangeOn3WeeksGraph
                                                    ? Colors.redAccent
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "Range",
                                            style: TextStyle(
                                                color: AppColors.textColor),
                                          ),
                                          Icon(
                                            Icons.fiber_manual_record_rounded,
                                            color: isRangeOn3WeeksGraph
                                                ? Colors.green
                                                : Colors.grey,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 25,
                                child: FlatButton(
                                    onPressed: () {
                                      if (isMinMaxOn3WeeksGraph) {
                                        setState(() {
                                          isMinMaxOn3WeeksGraph = false;
                                        });
                                      } else {
                                        setState(() {
                                          isMinMaxOn3WeeksGraph = true;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "--",
                                            style: TextStyle(
                                                color: isMinMaxOn3WeeksGraph
                                                    ? Colors.orangeAccent
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "-- ",
                                            style: TextStyle(
                                                color: isMinMaxOn3WeeksGraph
                                                    ? Colors.yellowAccent
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "Min Max Line",
                                            style: TextStyle(
                                                color: AppColors.textColor),
                                          ),
                                          Icon(
                                            Icons.fiber_manual_record_rounded,
                                            color: isMinMaxOn3WeeksGraph
                                                ? Colors.green
                                                : Colors.grey,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          LineChart(
                            LineChartData(
                              extraLinesData: isRangeOn3WeeksGraph
                                  ? ExtraLinesData(horizontalLines: [
                                      HorizontalLine(
                                        //y: isSwitched? 75:0,
                                        y: 37.5,
                                        color: Colors.redAccent,
                                        strokeWidth: 1,
                                      ),

                                      // HorizontalLine(
                                      //
                                      //   //y: isSwitched? 75:0,
                                      //   y: 85,
                                      //   color: Colors.redAccent,
                                      //   strokeWidth: 1,
                                      // ),
                                    ])
                                  : ExtraLinesData(),
                              minX: 0,
                              maxX: 6,
                              minY: 30,
                              maxY: 45,
                              titlesData: FlTitlesData(
                                bottomTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 6,
                                    getTitles: (value) {
                                      if (value.toInt() % 1 == 0) {
                                        return getTimes(value.toInt(), 'day');
                                      } else {
                                        return '';
                                      }
                                    }),
                                leftTitles: SideTitles(
                                  showTitles: true,
                                  getTitles: (value) {
                                    if (value.toInt() % 5 == 0) {
                                      return value.toString() + '°C';
                                    } else {
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
                                  spots: [
                                    FlSpot(0, 38),
                                    FlSpot(1, 37),
                                    FlSpot(2, 39),
                                    FlSpot(3, 37),
                                    FlSpot(4, 38),
                                    FlSpot(5, 39),
                                    FlSpot(6, 37)
                                  ], // mean data, index 1 = avg
                                  isCurved: false,
                                  colors: gradientColors,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: true),
                                  //barWidth: 1,
                                  belowBarData: BarAreaData(
                                      show: true,
                                      colors: gradientColors
                                          .map((color) =>
                                              color.withOpacity(0.15))
                                          .toList()),
                                ),

                                LineChartBarData(
                                  spots: [
                                    FlSpot(0, 95),
                                    FlSpot(1, 110),
                                    FlSpot(2, 99),
                                    FlSpot(3, 95),
                                    FlSpot(4, 110),
                                    FlSpot(5, 99),
                                    FlSpot(6, 110)
                                  ],
                                  isCurved: false,
                                  colors: [Colors.deepOrangeAccent],
                                  barWidth: 2,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                  show: isMinMaxOn3WeeksGraph ? true : false,
                                  //barWidth: 1,
                                ),

                                LineChartBarData(
                                  spots: [
                                    FlSpot(0, 70),
                                    FlSpot(1, 77),
                                    FlSpot(2, 69),
                                    FlSpot(3, 65),
                                    FlSpot(4, 77),
                                    FlSpot(5, 69),
                                    FlSpot(6, 69)
                                  ],
                                  isCurved: false,
                                  colors: [Colors.yellowAccent],
                                  barWidth: 2,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                  show: isMinMaxOn3WeeksGraph ? true : false,
                                  //barWidth: 1,
                                ),

                                // LineChartBarData(
                                //   spots: generateSpots(dataToPlot, 3),    // deviation negative
                                //   isCurved: true,
                                //   colors: [Colors.black54],
                                //   barWidth: 1,
                                //   isStrokeCapRound: true,
                                //   show: isStdDeviationOnFirstGraph? true: false,
                                //   dotData: FlDotData(show: false),
                                //   //barWidth: 1,
                                //
                                // ),
                                //
                                // LineChartBarData(
                                //   spots: generateSpots(dataToPlot, 4),    // deviation positive
                                //   isCurved: true,
                                //   colors: [Colors.black54],
                                //   barWidth: 1,
                                //   isStrokeCapRound: true,
                                //   show: isStdDeviationOnFirstGraph? true: false,
                                //   dotData: FlDotData(show: false),
                                //   //barWidth: 1,
                                //
                                // ),
                              ],
                              axisTitleData: FlAxisTitleData(
                                bottomTitle: AxisTitle(
                                    showTitle: true, titleText: '', margin: 5),
                                leftTitle: AxisTitle(
                                    showTitle: true, titleText: '', margin: 0),
                              ),
                              // lineTouchData: LineTouchData(getTouchedSpotIndicator:
                              //     (LineChartBarData barData,
                              //         List<int> spotIndexes) {
                              //   return spotIndexes.map((spotIndex) {
                              //     final FlSpot spot = barData.spots[spotIndex];
                              //
                              //     _touchedIndex = spotIndex;
                              //     _touchedSpotValue = spot
                              //         .x; //double (getting the x value or y value)
                              //
                              //     // if (spot.x == 0 || spot.x == 30 || spot.x == 29) {
                              //     //   return null;
                              //     // }
                              //   }).toList();
                              // }, touchCallback: (LineTouchResponse touchResponse) {
                              //   if (touchResponse.touchInput is FlPanEnd ||
                              //       touchResponse.touchInput is FlLongPressEnd) {
                              //     //goto next page for details
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => PlotDetails(
                              //           touchedIndex: _touchedIndex,
                              //           touchedScale: 'hr',
                              //         ),
                              //       ),
                              //     );
                              //     setState(() {
                              //       print('touched index---> $_touchedIndex');
                              //     });
                              //   } else {
                              //     print('wait');
                              //   }
                              // }),
                            ),
                          ),
                        ],
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
              title: Text("Oxygen Saturation", style: TextStyle(fontSize: 20)),
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
                    Container(
                      width: 335,
                      //height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[100],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Center(
                              child: Text("Last 1 Hour",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor)),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 25,
                                child: FlatButton(
                                    onPressed: () {
                                      if (isRangeOn1HourGraph) {
                                        setState(() {
                                          isRangeOn1HourGraph = false;
                                        });
                                      } else {
                                        setState(() {
                                          isRangeOn1HourGraph = true;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "---- ",
                                            style: TextStyle(
                                                color: isRangeOn1HourGraph
                                                    ? Colors.redAccent
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "Range",
                                            style: TextStyle(
                                                color: AppColors.textColor),
                                          ),
                                          Icon(
                                            Icons.fiber_manual_record_rounded,
                                            color: isRangeOn1HourGraph
                                                ? Colors.green
                                                : Colors.grey,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 25,
                                child: FlatButton(
                                    onPressed: () {
                                      if (isStdDeviationOn1HourGraph) {
                                        setState(() {
                                          isStdDeviationOn1HourGraph = false;
                                        });
                                      } else {
                                        setState(() {
                                          isStdDeviationOn1HourGraph = true;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "---- ",
                                            style: TextStyle(
                                                color:
                                                    isStdDeviationOn1HourGraph
                                                        ? Colors.black54
                                                        : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "Standard Deviation",
                                            style: TextStyle(
                                                color: AppColors.textColor),
                                          ),
                                          Icon(
                                            Icons.fiber_manual_record_rounded,
                                            color: isStdDeviationOn1HourGraph
                                                ? Colors.green
                                                : Colors.grey,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          LineChart(
                            LineChartData(
                              extraLinesData: isRangeOn1HourGraph
                                  ? ExtraLinesData(horizontalLines: [
                                      HorizontalLine(
                                        //y: isSwitched? 75:0,
                                        y: 95,
                                        color: Colors.redAccent,
                                        strokeWidth: 1,
                                      ),

                                      // HorizontalLine(
                                      //
                                      //   //y: isSwitched? 75:0,
                                      //   y: 85,
                                      //   color: Colors.redAccent,
                                      //   strokeWidth: 1,
                                      // ),
                                    ])
                                  : ExtraLinesData(),
                              minX: 0,
                              maxX: maxX_range_spo2,
                              minY: 85,
                              maxY: 105,
                              titlesData: FlTitlesData(
                                bottomTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 6,
                                    getTitles: (value) {
                                      if (value.toInt() % 15 == 0) {
                                        return getTimes(value.toInt(), 'min');
                                      } else {
                                        return '';
                                      }
                                    }),
                                leftTitles: SideTitles(
                                  showTitles: true,
                                  getTitles: (value) {
                                    if (value.toInt() % 5 == 0 &&
                                        value.toInt() <= 100) {
                                      return value.toInt().toString() + '%';
                                    } else {
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
                                  spots: generateSpots(dataToPlot_spo2,
                                      dataIndex_to_show), // mean data, index 1 = avg
                                  isCurved: true,
                                  colors: gradientColors,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                  //barWidth: 1,
                                  belowBarData: BarAreaData(
                                      show: true,
                                      colors: gradientColors
                                          .map((color) =>
                                              color.withOpacity(0.15))
                                          .toList()),
                                ),

                                LineChartBarData(
                                  spots: generateSpots(
                                      dataToPlot_spo2, 3), // deviation negative
                                  isCurved: true,
                                  colors: [Colors.black54],
                                  barWidth: 1,
                                  isStrokeCapRound: true,
                                  show:
                                      isStdDeviationOn1HourGraph ? true : false,
                                  dotData: FlDotData(show: false),
                                  //barWidth: 1,
                                ),

                                LineChartBarData(
                                  spots: generateSpots(
                                      dataToPlot_spo2, 4), // deviation positive
                                  isCurved: true,
                                  colors: [Colors.black54],
                                  barWidth: 1,
                                  isStrokeCapRound: true,
                                  show:
                                      isStdDeviationOn1HourGraph ? true : false,
                                  dotData: FlDotData(show: false),
                                  //barWidth: 1,
                                ),
                              ],
                              axisTitleData: FlAxisTitleData(
                                bottomTitle: AxisTitle(
                                    showTitle: true, titleText: '', margin: 5),
                                leftTitle: AxisTitle(
                                    showTitle: true, titleText: '', margin: 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 335,
                      //height: 300,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[100],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Center(
                              child: Text("Last 24 Hours",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor)),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 25,
                                child: FlatButton(
                                    onPressed: () {
                                      if (isRangeOn24HoursGraph) {
                                        setState(() {
                                          isRangeOn24HoursGraph = false;
                                        });
                                      } else {
                                        setState(() {
                                          isRangeOn24HoursGraph = true;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "---- ",
                                            style: TextStyle(
                                                color: isRangeOn24HoursGraph
                                                    ? Colors.green
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "Range",
                                            style: TextStyle(
                                                color: AppColors.textColor),
                                          ),
                                          Icon(
                                            Icons.fiber_manual_record_rounded,
                                            color: isRangeOn24HoursGraph
                                                ? Colors.green
                                                : Colors.grey,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 25,
                                child: FlatButton(
                                    onPressed: () {
                                      if (isStdDeviationOn24HoursGraph) {
                                        setState(() {
                                          isStdDeviationOn24HoursGraph = false;
                                        });
                                      } else {
                                        setState(() {
                                          isStdDeviationOn24HoursGraph = true;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "---- ",
                                            style: TextStyle(
                                                color:
                                                    isStdDeviationOn24HoursGraph
                                                        ? Colors.black54
                                                        : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "Standard Deviation",
                                            style: TextStyle(
                                                color: AppColors.textColor),
                                          ),
                                          Icon(
                                            Icons.fiber_manual_record_rounded,
                                            color: isStdDeviationOn24HoursGraph
                                                ? Colors.green
                                                : Colors.grey,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 25,
                                child: FlatButton(
                                    onPressed: () {
                                      if (isMinMaxOn24HoursGraph) {
                                        setState(() {
                                          isMinMaxOn24HoursGraph = false;
                                        });
                                      } else {
                                        setState(() {
                                          isMinMaxOn24HoursGraph = true;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "--",
                                            style: TextStyle(
                                                color: isMinMaxOn24HoursGraph
                                                    ? Colors.orangeAccent
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "-- ",
                                            style: TextStyle(
                                                color: isMinMaxOn24HoursGraph
                                                    ? Colors.yellowAccent
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "Min Max Line",
                                            style: TextStyle(
                                                color: AppColors.textColor),
                                          ),
                                          Icon(
                                            Icons.fiber_manual_record_rounded,
                                            color: isMinMaxOn24HoursGraph
                                                ? Colors.green
                                                : Colors.grey,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          LineChart(
                            LineChartData(
                              extraLinesData: isRangeOn24HoursGraph
                                  ? ExtraLinesData(horizontalLines: [
                                      HorizontalLine(
                                        y: 95,
                                        color: Colors.green,
                                        strokeWidth: 1,
                                      ),
                                    ])
                                  : ExtraLinesData(),
                              minX: 0,
                              maxX: maxX_range_hourly_spo2,
                              minY: 85,
                              maxY: 105,
                              titlesData: FlTitlesData(
                                bottomTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 6,
                                    getTitles: (value) {
                                      if (value.toInt() % 6 == 0) {
                                        return getTimes(value.toInt(), 'day');
                                      } else {
                                        return '';
                                      }
                                    }),
                                leftTitles: SideTitles(
                                  showTitles: true,
                                  getTitles: (value) {
                                    if (value.toInt() % 5 == 0 &&
                                        value.toInt() <= 100) {
                                      return value.toInt().toString() + '%';
                                    } else {
                                      return '';
                                    }
                                  },
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: FlGridData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: generateHourlySpots_spo2(1),
                                  isCurved: true,
                                  colors: gradientColors,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                  //barWidth: 1,
                                  belowBarData: BarAreaData(
                                      show: true,
                                      colors: gradientColors
                                          .map((color) =>
                                              color.withOpacity(0.15))
                                          .toList()),
                                ),
                                LineChartBarData(
                                  spots: generateHourlySpots_spo2(0),
                                  isCurved: true,
                                  colors: [Colors.yellowAccent],
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                  show: isMinMaxOn24HoursGraph ? true : false,
                                  //barWidth: 1,
                                ),
                                LineChartBarData(
                                  spots: generateHourlySpots_spo2(2),
                                  isCurved: true,
                                  colors: [Colors.deepOrangeAccent],
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                  show: isMinMaxOn24HoursGraph ? true : false,
                                  //barWidth: 1,
                                ),
                                LineChartBarData(
                                  spots: generateHourlySpots_spo2(3),
                                  isCurved: true,
                                  colors: [Colors.grey],
                                  barWidth: 1,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                  show: isStdDeviationOn24HoursGraph
                                      ? true
                                      : false,
                                  //barWidth: 1,
                                ),
                                LineChartBarData(
                                  spots: generateHourlySpots_spo2(4),
                                  isCurved: true,
                                  colors: [Colors.grey],
                                  barWidth: 1,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                  show: isStdDeviationOn24HoursGraph
                                      ? true
                                      : false,
                                  //barWidth: 1,
                                ),
                              ],
                              axisTitleData: FlAxisTitleData(
                                bottomTitle: AxisTitle(
                                    showTitle: true, titleText: '', margin: 5),
                                leftTitle: AxisTitle(
                                    showTitle: true, titleText: '', margin: 0),
                              ),
                              lineTouchData: LineTouchData(
                                  getTouchedSpotIndicator:
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
                              }, touchCallback:
                                      (LineTouchResponse touchResponse) {
                                if (touchResponse.touchInput is FlPanEnd ||
                                    touchResponse.touchInput
                                        is FlLongPressEnd) {
                                  List data_to_send = processRange(
                                      whole_day_data_spo2.sublist(
                                          (_touchedIndex) * 1200,
                                          (_touchedIndex * 1200) + 1200),
                                      20);
                                  //goto next page for details
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlotDetails(
                                        touchedIndex: _touchedIndex,
                                        touchedScale: 'hour', //hour,min,day
                                        data_to_plot: data_to_send,
                                        long_data: data,
                                        touchedVSType: 'spo2',
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
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 335,
                      //height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[100],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Center(
                              child: Text("Last 7 Days Data",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor)),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 25,
                                child: FlatButton(
                                    onPressed: () {
                                      if (isRangeOn3WeeksGraph) {
                                        setState(() {
                                          isRangeOn3WeeksGraph = false;
                                        });
                                      } else {
                                        setState(() {
                                          isRangeOn3WeeksGraph = true;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "---- ",
                                            style: TextStyle(
                                                color: isRangeOn3WeeksGraph
                                                    ? Colors.redAccent
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "Range",
                                            style: TextStyle(
                                                color: AppColors.textColor),
                                          ),
                                          Icon(
                                            Icons.fiber_manual_record_rounded,
                                            color: isRangeOn3WeeksGraph
                                                ? Colors.green
                                                : Colors.grey,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 25,
                                child: FlatButton(
                                    onPressed: () {
                                      if (isMinMaxOn3WeeksGraph) {
                                        setState(() {
                                          isMinMaxOn3WeeksGraph = false;
                                        });
                                      } else {
                                        setState(() {
                                          isMinMaxOn3WeeksGraph = true;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "--",
                                            style: TextStyle(
                                                color: isMinMaxOn3WeeksGraph
                                                    ? Colors.orangeAccent
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "-- ",
                                            style: TextStyle(
                                                color: isMinMaxOn3WeeksGraph
                                                    ? Colors.yellowAccent
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "Min Max Line",
                                            style: TextStyle(
                                                color: AppColors.textColor),
                                          ),
                                          Icon(
                                            Icons.fiber_manual_record_rounded,
                                            color: isMinMaxOn3WeeksGraph
                                                ? Colors.green
                                                : Colors.grey,
                                            size: 10,
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          LineChart(
                            LineChartData(
                              extraLinesData: isRangeOn3WeeksGraph
                                  ? ExtraLinesData(horizontalLines: [
                                      HorizontalLine(
                                        //y: isSwitched? 75:0,
                                        y: 95,
                                        color: Colors.redAccent,
                                        strokeWidth: 1,
                                      ),

                                      // HorizontalLine(
                                      //
                                      //   //y: isSwitched? 75:0,
                                      //   y: 85,
                                      //   color: Colors.redAccent,
                                      //   strokeWidth: 1,
                                      // ),
                                    ])
                                  : ExtraLinesData(),
                              minX: 0,
                              maxX: 6,
                              minY: 85,
                              maxY: 105,
                              titlesData: FlTitlesData(
                                bottomTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 6,
                                    getTitles: (value) {
                                      if (value.toInt() % 1 == 0) {
                                        return getTimes(value.toInt(), 'day');
                                      } else {
                                        return '';
                                      }
                                    }),
                                leftTitles: SideTitles(
                                  showTitles: true,
                                  getTitles: (value) {
                                    if (value.toInt() % 5 == 0 &&
                                        value.toInt() <= 100) {
                                      return value.toInt().toString() + '%';
                                    } else {
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
                                  spots: [
                                    FlSpot(0, 95),
                                    FlSpot(1, 96),
                                    FlSpot(2, 95),
                                    FlSpot(3, 95),
                                    FlSpot(4, 94),
                                    FlSpot(5, 95),
                                    FlSpot(6, 95)
                                  ], // mean data, index 1 = avg
                                  isCurved: false,
                                  colors: gradientColors,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: true),
                                  //barWidth: 1,
                                  belowBarData: BarAreaData(
                                      show: true,
                                      colors: gradientColors
                                          .map((color) =>
                                              color.withOpacity(0.15))
                                          .toList()),
                                ),

                                LineChartBarData(
                                  spots: [
                                    FlSpot(0, 99),
                                    FlSpot(1, 100),
                                    FlSpot(2, 101),
                                    FlSpot(3, 100),
                                    FlSpot(4, 101),
                                    FlSpot(5, 99),
                                    FlSpot(6, 99)
                                  ],
                                  isCurved: false,
                                  colors: [Colors.deepOrangeAccent],
                                  barWidth: 2,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                  show: isMinMaxOn3WeeksGraph ? true : false,
                                  //barWidth: 1,
                                ),

                                LineChartBarData(
                                  spots: [
                                    FlSpot(0, 92),
                                    FlSpot(1, 91),
                                    FlSpot(2, 93),
                                    FlSpot(3, 89),
                                    FlSpot(4, 90),
                                    FlSpot(5, 91),
                                    FlSpot(6, 90)
                                  ],
                                  isCurved: false,
                                  colors: [Colors.yellowAccent],
                                  barWidth: 2,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                  show: isMinMaxOn3WeeksGraph ? true : false,
                                  //barWidth: 1,
                                ),

                                // LineChartBarData(
                                //   spots: generateSpots(dataToPlot, 3),    // deviation negative
                                //   isCurved: true,
                                //   colors: [Colors.black54],
                                //   barWidth: 1,
                                //   isStrokeCapRound: true,
                                //   show: isStdDeviationOnFirstGraph? true: false,
                                //   dotData: FlDotData(show: false),
                                //   //barWidth: 1,
                                //
                                // ),
                                //
                                // LineChartBarData(
                                //   spots: generateSpots(dataToPlot, 4),    // deviation positive
                                //   isCurved: true,
                                //   colors: [Colors.black54],
                                //   barWidth: 1,
                                //   isStrokeCapRound: true,
                                //   show: isStdDeviationOnFirstGraph? true: false,
                                //   dotData: FlDotData(show: false),
                                //   //barWidth: 1,
                                //
                                // ),
                              ],
                              axisTitleData: FlAxisTitleData(
                                bottomTitle: AxisTitle(
                                    showTitle: true, titleText: '', margin: 5),
                                leftTitle: AxisTitle(
                                    showTitle: true, titleText: '', margin: 0),
                              ),
                              // lineTouchData: LineTouchData(getTouchedSpotIndicator:
                              //     (LineChartBarData barData,
                              //         List<int> spotIndexes) {
                              //   return spotIndexes.map((spotIndex) {
                              //     final FlSpot spot = barData.spots[spotIndex];
                              //
                              //     _touchedIndex = spotIndex;
                              //     _touchedSpotValue = spot
                              //         .x; //double (getting the x value or y value)
                              //
                              //     // if (spot.x == 0 || spot.x == 30 || spot.x == 29) {
                              //     //   return null;
                              //     // }
                              //   }).toList();
                              // }, touchCallback: (LineTouchResponse touchResponse) {
                              //   if (touchResponse.touchInput is FlPanEnd ||
                              //       touchResponse.touchInput is FlLongPressEnd) {
                              //     //goto next page for details
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => PlotDetails(
                              //           touchedIndex: _touchedIndex,
                              //           touchedScale: 'hr',
                              //         ),
                              //       ),
                              //     );
                              //     setState(() {
                              //       print('touched index---> $_touchedIndex');
                              //     });
                              //   } else {
                              //     print('wait');
                              //   }
                              // }),
                            ),
                          ),
                        ],
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
                            spots: generateSpots(
                                dataToPlot_temp, dataIndex_to_show),
                            colors: [Colors.orange],
                            dotData: FlDotData(show: false),
                            barWidth: 1,
                            belowBarData: BarAreaData(
                                show: true,
                                colors: [Colors.orangeAccent.withOpacity(.5)]),
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
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2, double y3) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        color: Color(0xff01579b),
        width: width,
      ),
      BarChartRodData(
        y: y2,
        color: Color(0xffff5182),
        width: width,
      ),
      BarChartRodData(
        y: y3,
        color: Color(0xffff5182),
        width: width,
      ),
    ]);
  }

  List<FlSpot> generateSpots(List data, int index) {
    List<FlSpot> spots = data.asMap().entries.map((e) {
      double y = double.tryParse((e.value[index] + randomNumber2).toString());
      return FlSpot(e.key.toDouble(), y);
    }).toList();

    return spots;
  }

  List<FlSpot> generateHourlySpots(int index) {
    List<FlSpot> spots = hourlyDataToPlot_hr.asMap().entries.map((e) {
      double y =
          double.tryParse((e.value[index] + random.nextInt(6)).toString());
      return FlSpot(e.key.toDouble(), y);
    }).toList();

    return spots;
  }

  List<FlSpot> generateHourlySpots_spo2(int index) {
    List<FlSpot> spots = hourlyDataToPlot_spo2.asMap().entries.map((e) {
      double y =
          double.tryParse((e.value[index] + random.nextInt(2)).toString());
      if (y > 100) {
        y = 100;
      } else if (y == 100) {
        y = y - random.nextInt(2);
      }
      return FlSpot(e.key.toDouble(), y);
    }).toList();

    return spots;
  }
}
