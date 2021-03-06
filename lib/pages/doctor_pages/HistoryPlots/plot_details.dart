import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vital_signs_ui_template/elements/ButtonWidget.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';
import 'package:vital_signs_ui_template/pages/Dashboard/AbnormalVsBoard.dart';

import '../../../core/consts.dart';
import 'PlotDataProcessing.dart';

class PlotDetails extends StatefulWidget {
  final int touchedIndex;
  final String touchedScale;
  final String touchedVSType;
  final List data_to_plot;
  final List long_data;
  final String timeOfData;

  final bool showAbnormalDots;

  const PlotDetails(
      {Key key,
      this.touchedIndex,
      this.touchedScale,
      this.data_to_plot,
      this.long_data,
      this.showAbnormalDots = false,
      this.touchedVSType = '',
      this.timeOfData})
      : super(key: key);

  @override
  _PlotDetailsState createState() => _PlotDetailsState();
}

class _PlotDetailsState extends State<PlotDetails> {
  int _touchedIndex;
  String _touchedScale;
  List _data_to_plot;
  double _maxX_range;
  String _touchedVSType;
  bool isRangeOnSpecificHour = false;
  bool isEmergencyDotOn = false; //false
  bool isMinMaxOn = false;
  bool isStdDeviationOn24HoursGraph = false;
  List _long_data;
  double _currentSliderValue = 30;
  List _demo_chart;
  double _yMinRange;
  double _yMaxRange;
  double _normalRange1 = 75;
  double _normalRange2 = 85;
  int _typeOfTimeInterval;
  double _emergencyDotBracket;
  DateTime now;
  String _timeOfData;
  String _vsTitle = '';
  bool changeBottomNavBar = true;

  Random random = new Random();
  int randomInt;

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    //const Color(0xff02d39a),
  ];

  // void initial_data_process(List data) {
  //   // int length = data.length;
  //   // List sub_data = data.sublist(length-1200,length);
  //   _long_data = processRange(data, 20, "hr");
  //   // dataIndex_to_show = 1;   // 0 = min, 1 = average, 2 = max
  //   // maxX_range = dataToPlot.length*1.0;
  // }

  String getTimes(int timeToAdd, String typeOfTime) {
    // now = DateTime.now();
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
    now = DateTime.now();
    _touchedIndex = widget.touchedIndex;
    _touchedScale = widget.touchedScale;
    _data_to_plot = widget.data_to_plot;
    _maxX_range = _data_to_plot.length * 1.0;
    _long_data = widget.long_data;
    _touchedVSType = widget.touchedVSType;
    _long_data = processRange(_long_data, 20, "hr");

    _timeOfData =
        widget.timeOfData ?? DateFormat().add_Md().add_jm().format(now);

    isEmergencyDotOn = widget.showAbnormalDots; //false as default

    super.initState();

    switch (_touchedScale) {
      case 'min':
        _typeOfTimeInterval = 15;
        break;
      case 'hour':
        _typeOfTimeInterval = 6;
        break;
      case 'day':
        _typeOfTimeInterval = 1;
        break;
      default:
        _typeOfTimeInterval = 1;
    }

    switch (_touchedVSType) {
      case 'hr':
        _yMinRange = 30;
        _yMaxRange = 150;
        randomInt = 15;
        _normalRange1 = 60;
        _normalRange2 = 100;
        _emergencyDotBracket = 100;
        _vsTitle = 'Heart Rate';
        changeBottomNavBar = false; //for testing only
        break;
      case 'temp':
        _yMinRange = 30;
        _yMaxRange = 45;
        _emergencyDotBracket = 38;
        _vsTitle = 'Temperature';
        break;
      case 'spo2':
        _yMinRange = 85;
        _yMaxRange = 105;
        randomInt = 6;
        _normalRange1 = 91;
        _normalRange2 = 91;
        _emergencyDotBracket = 91;
        changeBottomNavBar = true; //for testing only
        _vsTitle = 'Oxygen Saturation';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        height: 130, //no use of this fixed height
        turnOffBackButton: false,
        turnOffSettingsButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              child: Center(
                child: Text("$_vsTitle - $_timeOfData",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor)),
              ),
            ),
            Container(
              width: 335,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[100],
              ),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                        child: FlatButton(
                            onPressed: () {
                              if (isRangeOnSpecificHour) {
                                setState(() {
                                  isRangeOnSpecificHour = false;
                                });
                              } else {
                                setState(() {
                                  isRangeOnSpecificHour = true;
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "---- ",
                                    style: TextStyle(
                                        color: isRangeOnSpecificHour
                                            ? Colors.redAccent
                                            : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    "Normal zone",
                                    style: TextStyle(
                                      color: AppColors.textColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Icon(
                                    Icons.fiber_manual_record_rounded,
                                    color: isRangeOnSpecificHour
                                        ? Colors.green
                                        : Colors.grey,
                                    size: 10,
                                  ),
                                ],
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 20,
                        child: FlatButton(
                            onPressed: () {
                              if (isEmergencyDotOn) {
                                setState(() {
                                  isEmergencyDotOn = false;
                                });
                              } else {
                                setState(() {
                                  isEmergencyDotOn = true;
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "---- ",
                                    style: TextStyle(
                                        color: isEmergencyDotOn
                                            ? Colors.redAccent
                                            : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    "Abnormal",
                                    style: TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 12),
                                  ),
                                  Icon(
                                    Icons.fiber_manual_record_rounded,
                                    color: isEmergencyDotOn
                                        ? Colors.green
                                        : Colors.grey,
                                    size: 10,
                                  ),
                                ],
                              ),
                            )),
                      ),
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
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "---- ",
                                    style: TextStyle(
                                        color: isStdDeviationOn24HoursGraph
                                            ? Colors.black54
                                            : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    "Variation",
                                    style:
                                        TextStyle(color: AppColors.textColor),
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
                      SizedBox(
                        height: 20,
                        child: FlatButton(
                            onPressed: () {
                              if (isMinMaxOn) {
                                setState(() {
                                  isMinMaxOn = false;
                                });
                              } else {
                                setState(() {
                                  isMinMaxOn = true;
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "---- ",
                                    style: TextStyle(
                                        color: isMinMaxOn
                                            ? Colors.redAccent
                                            : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    "Min & Max",
                                    style: TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 12),
                                  ),
                                  Icon(
                                    Icons.fiber_manual_record_rounded,
                                    color:
                                        isMinMaxOn ? Colors.green : Colors.grey,
                                    size: 10,
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        extraLinesData: isRangeOnSpecificHour
                            ? ExtraLinesData(
                                horizontalLines: [
                                  HorizontalLine(
                                    y: _normalRange1,
                                    color: Colors.redAccent,
                                    strokeWidth: 1,
                                  ),
                                  HorizontalLine(
                                    y: _normalRange2,
                                    color: Colors.redAccent,
                                  )
                                ],
                              )
                            : ExtraLinesData(),

                        minX: 0,
                        maxX: _maxX_range,
                        minY: _yMinRange,
                        maxY: _yMaxRange,
                        titlesData: FlTitlesData(
                          bottomTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 6,
                              getTitles: (value) {
                                if (value.toInt() % (_maxX_range / 3) == 0) {
                                  return getTimes(value.toInt(), _touchedScale);
                                } else {
                                  return '';
                                }
                                // switch (value.toInt()) {
                                //   case 0:
                                //     return '0';
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
                              if (_touchedVSType == 'spo2') {
                                if (value.toInt() % 5 == 0 &&
                                    value.toInt() <= 100) {
                                  return value.toInt().toString() + '%';
                                } else {
                                  return '';
                                }
                              } else if (_touchedVSType == 'temp') {
                                if (value.toInt() % 5 == 0) {
                                  return value.toString() + '??C';
                                } else {
                                  return '';
                                }
                              } else {
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
                              }
                            },
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(show: false),
                        lineBarsData: [
                          //loadAsset(),
                          LineChartBarData(
                            spots: generateHourlySpots(_data_to_plot, 1),
                            isCurved: true,

                            colors: gradientColors,
                            barWidth: 3,
                            isStrokeCapRound: true,

                            dotData: isEmergencyDotOn
                                ? FlDotData(
                                    show: true,
                                    checkToShowDot: (spot, belowBarData) {
                                      return _touchedVSType == 'spo2'
                                          ? (spot.y < _emergencyDotBracket)
                                          : (spot.y > _emergencyDotBracket);
                                    },
                                    getDotPainter: (spot, percent, barData,
                                            index) =>
                                        //FlDotCirclePainter(radius: 5, color: Colors.red.withOpacity(0.5)),
                                        FlDotCirclePainter(
                                            radius: 3, color: Colors.redAccent),
                                  )
                                : FlDotData(show: false),

                            //barWidth: 1,
                            belowBarData: BarAreaData(
                                show: true,
                                colors: gradientColors
                                    .map((color) => color.withOpacity(0.15))
                                    .toList()),
                          ),
                          LineChartBarData(
                            spots: generateHourlySpots(_data_to_plot, 0),
                            isCurved: true,
                            colors: [Colors.yellowAccent],
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            show: isMinMaxOn ? true : false,
                            //barWidth: 1,
                          ),
                          LineChartBarData(
                            spots: generateHourlySpots(_data_to_plot, 2),
                            isCurved: true,
                            colors: [Colors.deepOrangeAccent],
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            show: isMinMaxOn ? true : false,
                            //barWidth: 1,
                          ),
                          LineChartBarData(
                            spots: generateHourlySpots(_data_to_plot, 3),
                            isCurved: true,
                            colors: [Colors.grey],
                            barWidth: 1,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            show: isStdDeviationOn24HoursGraph ? true : false,
                            //barWidth: 1,
                          ),

                          LineChartBarData(
                            spots: generateHourlySpots(_data_to_plot, 4),
                            isCurved: true,
                            colors: [Colors.grey],
                            barWidth: 1,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            show: isStdDeviationOn24HoursGraph ? true : false,
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
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Slider(
                  value: _currentSliderValue,
                  min: 15,
                  max: 180,
                  divisions: 11,
                  label: _currentSliderValue.round().toString(),
                  onChanged: (double value) {
                    updateRange(value.toInt());
                    setState(() {
                      _currentSliderValue = value;
                    });
                  }),
            ),
            Text(
              'Use slider to change the timeline',
              style: TextStyle(
                  color: AppColors.textColor, fontStyle: FontStyle.italic),
            ),
            Container(
              padding: EdgeInsets.all(30),
              child: ButtonWidget(
                buttonTitle: 'ALL CHARTS',
                buttonHeight: 50,
                onTapFunction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AbnormalVsBoard(
                        selectedIndexToOpen: 1,
                        openedHistoryVSType: 'spo2',
                      ),
                    ),
                  );
                },
              ),
            ),
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
            icon: Icon(changeBottomNavBar
                ? Icons.warning
                : Icons.perm_phone_msg_rounded),
            title: Text(changeBottomNavBar ? 'HELP' : 'Contact'),
          ),
        ],
        // currentIndex: _selectedIndex,
        selectedItemColor: AppColors.deccolor1,
        // onTap: _onItemTapped,
      ),
    );
  }

  updateRange(int rangeVal) {
    if (rangeVal != -1) {
      rangeVal = rangeVal;
      _demo_chart = _long_data
          .getRange(_long_data.length - rangeVal, _long_data.length)
          .toList();
    } else {
      _demo_chart = _long_data;
    }
    setState(() {
      _maxX_range = 1.00 * _demo_chart.length;
      _data_to_plot = _demo_chart;
      print('len---> ${_data_to_plot.length}');
    });
  }

  List<FlSpot> generateHourlySpots(List data_to_plot, int index,
      [int randomIntToRemove = 0]) {
    // if(randomIntToRemove != 0){
    //
    // }
    List<FlSpot> spots = data_to_plot.asMap().entries.map((e) {
      double y = double.tryParse(
          (e.value[index] + randomInt - randomIntToRemove).toString());
      return FlSpot(e.key.toDouble(), y);
    }).toList();

    return spots;
  }
}
