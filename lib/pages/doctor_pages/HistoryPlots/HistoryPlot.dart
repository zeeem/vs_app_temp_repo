import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:scidart/numdart.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';
import 'package:vital_signs_ui_template/pages/doctor_pages/HistoryPlots/plot_details.dart';
import 'PlotDataProcessing.dart';

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
  List<dynamic> hourlyDataToPlot = [];
  List<dynamic> demo_chart = [];
  List<dynamic> whole_day_data = [];
  double maxX_range = 60;
  double maxX_range_hourly = 24;
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

  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;


  int touchedGroupIndex;

  List<double> bardata = [];

  bool hrExpansion, rrExpansion, spo2Expansion, tempExpansion;

  void _onItemTapped(int index) {
    _selectedIndex = index;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => docPatientListPage(selectedIndex: index),
      ),
    );
  }

  void initial_plot(List data)
  {
    int length = data.length;
    List sub_data = data.sublist(length-1200,length);
    dataToPlot = processRange(sub_data, 20, "hr");
    dataIndex_to_show = 1;   // 0 = min, 1 = average, 2 = max
    maxX_range = dataToPlot.length*1.0;
  }

  void initial_hourly_plot(List data)
  {
    int length = data.length;
    List sub_data = data.sublist(length-28800,length);
    whole_day_data = sub_data;
    hourlyDataToPlot = processRange(sub_data, 1200, "hr", 'median');
    //dataIndex_to_show = 1;   // 0 = min, 1 = average, 2 = max
    maxX_range_hourly = hourlyDataToPlot.length*1.0;
  }

  @override
  void initState() {
    data = widget.data;
    xMax = data.length;
    //dataToPlot = data;
    initial_plot(data);   //Initial function to show last 1 hour data (1 min average)
    initial_hourly_plot(data);  //Initial hourly data


    print(dataToPlot);

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
  }

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    //const Color(0xff02d39a),
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
        turnOffBackButton: false,
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
                                child: Text("Last 1 Hour", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textColor)),
                              ),
                            ),
                            LineChart(
                              LineChartData(
                                extraLinesData: ExtraLinesData(horizontalLines: [
                                  HorizontalLine(
                                    y: 75,
                                    color: Colors.redAccent,
                                    strokeWidth: 1,
                                  ),
                                  HorizontalLine(
                                    y: 85,
                                    color: Colors.redAccent,

                                  )
                                ]),
                                minX: 0,
                                maxX: maxX_range,
                                minY: 30,
                                maxY: 150,
                                titlesData: FlTitlesData(
                                  bottomTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 6,
                                      getTitles: (value) {
                                        switch (value.toInt()) {
                                          case 0:
                                            return '1m';
                                          case 15:
                                            return '15m';
                                          case 30:
                                            return '30m';
                                          case 45:
                                            return '45m';
                                          case 60:
                                            return '1h';
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
                                            .map((color) => color.withOpacity(0.15))
                                            .toList()),
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
                                child: Text("Last 24 Hours", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textColor)),
                              ),
                            ),
                            LineChart(
                              LineChartData(
                                extraLinesData: ExtraLinesData(horizontalLines: [
                                  HorizontalLine(
                                    y: 75,
                                    color: Colors.black26,
                                    strokeWidth: 1,
                                  ),
                                  HorizontalLine(
                                    y: 85,
                                    color: Colors.black26,
                                    strokeWidth: 1,
                                  )
                                ]),
                                minX: 0,
                                maxX: maxX_range_hourly,
                                minY: 30,
                                maxY: 150,
                                titlesData: FlTitlesData(
                                  bottomTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 6,
                                      getTitles: (value) {
                                        switch (value.toInt()) {
                                          case 1:
                                            return '1h';
                                          case 6:
                                            return '6h';
                                          case 12:
                                            return '12h';
                                          case 18:
                                            return '18h';
                                          case 24:
                                            return '24h';
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
                                    dotData: FlDotData(show: true),
                                    //barWidth: 1,
                                    belowBarData: BarAreaData(
                                        show: true,
                                        colors: gradientColors
                                            .map((color) => color.withOpacity(0.15))
                                            .toList()),


                                  ),


                                  LineChartBarData(
                                    spots: generateHourlySpots(0),
                                    isCurved: true,
                                    colors: [Colors.yellowAccent],
                                    barWidth: 3,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(show: false),
                                    //barWidth: 1,

                                  ),

                                  LineChartBarData(
                                    spots: generateHourlySpots(2),
                                    isCurved: true,
                                    colors: [Colors.deepOrangeAccent],
                                    barWidth: 3,
                                    isStrokeCapRound: true,
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
                                    List data_to_send = processRange(whole_day_data.sublist((_touchedIndex)*1200, (_touchedIndex*1200)+1200), 20);
                                    //goto next page for details
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlotDetails(
                                          touchedIndex: _touchedIndex,
                                          touchedScale: 'hr',
                                          data_to_plot: data_to_send,
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

                      Container(
                        padding: EdgeInsets.all(20),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: Colors.grey[100],
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(bottom: 10),
                                            child: Center(
                                              child: Text("Last 3 Weeks", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textColor)),
                                            ),
                                          ),
                                          Expanded(
                                            child: BarChart(
                                              BarChartData(
                                                maxY: 20,
                                                barTouchData: BarTouchData(
                                                    touchTooltipData: BarTouchTooltipData(
                                                      tooltipBgColor: Colors.grey,
                                                      getTooltipItem: (_a, _b, _c, _d) => null,
                                                    ),
                                                    touchCallback: (response) {
                                                      if (response.spot == null) {
                                                        setState(() {
                                                          touchedGroupIndex = -1;
                                                          showingBarGroups = List.of(rawBarGroups);
                                                        });
                                                        return;
                                                      }

                                                      touchedGroupIndex = response.spot.touchedBarGroupIndex;

                                                      setState(() {
                                                        if (response.touchInput is FlLongPressEnd ||
                                                            response.touchInput is FlPanEnd) {
                                                          touchedGroupIndex = -1;
                                                          showingBarGroups = List.of(rawBarGroups);
                                                        } else {
                                                          showingBarGroups = List.of(rawBarGroups);
                                                          if (touchedGroupIndex != -1) {
                                                            double sum = 0;
                                                            for (BarChartRodData rod
                                                            in showingBarGroups[touchedGroupIndex].barRods) {
                                                              sum += rod.y;
                                                            }
                                                            final avg =
                                                                sum / showingBarGroups[touchedGroupIndex].barRods.length;

                                                            showingBarGroups[touchedGroupIndex] =
                                                                showingBarGroups[touchedGroupIndex].copyWith(
                                                                  barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                                                                    return rod.copyWith(y: avg);
                                                                  }).toList(),
                                                                );
                                                          }
                                                        }
                                                      });
                                                    }),
                                                titlesData: FlTitlesData(
                                                  show: true,
                                                  bottomTitles: SideTitles(
                                                    showTitles: true,
                                                    // getTextStyles: (value) => const TextStyle(
                                                    //     color: Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14),
                                                    margin: 20,
                                                    getTitles: (double value) {
                                                      switch (value.toInt()) {
                                                        case 0:
                                                          return 'Week 1';
                                                        case 1:
                                                          return 'Week 2';
                                                        case 2:
                                                          return 'Week 3';
                                                        case 3:
                                                          return 'Week 4';
                                                      // case 4:
                                                      //   return 'Fr';
                                                      // case 5:
                                                      //   return 'St';
                                                      // case 6:
                                                      //   return 'Sn';
                                                        default:
                                                          return '';
                                                      }
                                                    },
                                                  ),
                                                  leftTitles: SideTitles(
                                                    showTitles: true,
                                                    // getTextStyles: (value) => const TextStyle(
                                                    //     color: Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14),
                                                    margin: 20,
                                                    reservedSize: 14,
                                                    getTitles: (value) {
                                                      if (value == 0) {
                                                        return '0';
                                                      } else if (value == 10) {
                                                        return '75';
                                                      } else if (value == 19) {
                                                        return '100';
                                                      } else {
                                                        return '';
                                                      }
                                                    },
                                                  ),
                                                ),
                                                borderData: FlBorderData(
                                                  show: false,
                                                ),
                                                barGroups: showingBarGroups,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),

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


  List<FlSpot> generateSpots() {
    List<FlSpot> spots = dataToPlot.asMap().entries.map((e) {
      double y = double.tryParse(e.value[dataIndex_to_show].toString());
      return FlSpot(e.key.toDouble(), y);
    }).toList();

    return spots;
  }

  List<FlSpot> generateHourlySpots(int index) {
    List<FlSpot> spots = hourlyDataToPlot.asMap().entries.map((e) {
      double y = double.tryParse(e.value[index].toString());
      return FlSpot(e.key.toDouble(), y);
    }).toList();

    return spots;
  }

}
