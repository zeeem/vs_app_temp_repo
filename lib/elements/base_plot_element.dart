import 'dart:async';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vital_signs_ui_template/elements/API_services.dart';

import '../core/configVS.dart';
import '../core/consts.dart';

class base_plot_element extends StatefulWidget {
  final List normalZone;
  final String vsType;
  final String vsScaleTimeType;
  final String vsDefaultType;
  final List<double> vsYAxisRange;
  final String vsYAxisUnit;
  final String plotTitle;
  final List plotData;

  const base_plot_element({
    Key key,
    this.normalZone = const [93, 101],
    this.vsType = 'spo2',
    this.vsScaleTimeType = 'min',
    this.vsDefaultType = 'mean',
    this.vsYAxisRange = const [85, 102],
    this.vsYAxisUnit = "%",
    this.plotTitle = "1 Hour Plot",
    this.plotData,
  }) : super(key: key);
  @override
  _base_plot_elementState createState() => _base_plot_elementState();
}

class _base_plot_elementState extends State<base_plot_element> {
  final GlobalKey<FormState> _keyDialogForm = new GlobalKey<FormState>();
  List _normalZone;
  String _vsType;
  String _vsScaleTimeType; //min,hr,day,month
  String _vsDefaultType; //mean = average, med = median

  List<double> _vsYAxisRange;
  String _vsYAxisUnit;
  String _plotTitle;
  List _plotData;

  bool isRangeOnSpecificHour = false;
  bool isEmergencyDotOn = false; //false
  bool isMinMaxOn = false;
  bool isStdDeviationOn24HoursGraph = false;

  String _selectedRadioButton;
  String selectedPlotScale;
  String selectedPlotScale_rangeSelector;

  String _selectedRadioButton_rangeSelector;

  bool _isLoading = true;

  bool _showCustomRange = false;

  DateTime now;
  DateTime selected_FromTime, selected_ToTime;

  int len;
  List temp_plot;

  _radioButtonhandler(String selectedScale) async {
    // DateTime timeFrom = DateTime.parse("2021-03-05 23:01:00.000Z");
    // DateTime timeTo;
    //
    // switch (selectedScale) {
    //   case 'min':
    //     timeTo = timeFrom.add(Duration(hours: 1));
    //     break;
    //   case 'hr':
    //     timeTo = timeFrom.add(Duration(hours: 24));
    //     _vsDefaultType = 'med';
    //     break;
    //   case 'day':
    //     timeTo = timeFrom.add(Duration(days: 4));
    //     _vsDefaultType = 'med';
    //     break;
    //   case 'month':
    //     timeTo = timeFrom.add(Duration(days: 30));
    //     _vsDefaultType = 'med';
    //     break;
    //   default:
    //     timeTo = timeFrom.add(Duration(hours: 1));
    //     break;
    // }

    _vsDefaultType = 'mean'; // added new

    _isLoading = true;
    //_plotData = await API_SERVICES.fetchVSData(timeFrom, timeTo, selectedScale);
    //Timer(Duration(seconds: 2), () {
    setState(() {
      selectedPlotScale = selectedScale;
      print('selected scale ==> $selectedPlotScale');
      _selectedRadioButton = selectedScale;
      _vsScaleTimeType = selectedScale;
      _isLoading = false;
    });
    //});
  }

  _radioButtonhandler_RangeSelector(String selectedScale) async {
    DateTime timeFrom = DateTime.parse("2021-03-05 23:01:00.000Z");
    DateTime timeTo;
    String selectedScale_toFetch = '';

    switch (selectedScale) {
      case '1h':
        timeTo = timeFrom.add(Duration(hours: 1));
        selectedScale_toFetch = 'min';
        break;
      case '3h':
        timeTo = timeFrom.add(Duration(hours: 3));
        selectedScale_toFetch = 'min';
        break;
      case '6h':
        timeTo = timeFrom.add(Duration(hours: 6));
        selectedScale_toFetch = 'min';
        break;
      case '1d':
        timeTo = timeFrom.add(Duration(days: 1));
        selectedScale_toFetch = 'hr';
        _vsDefaultType = 'med';
        break;
      case 'Custom':
        setState(() {
          selectedPlotScale_rangeSelector = selectedScale_toFetch;
          _selectedRadioButton_rangeSelector = selectedScale;
          _vsScaleTimeType = selectedScale_toFetch;
          _isLoading = false;
          if (_showCustomRange == false) {
            _showCustomRange = true;
          } else {
            _showCustomRange = false;
          }
          showDateSelectionDialogBox();
        });
        return;
      default:
        timeTo = timeFrom.add(Duration(hours: 1));
        selectedScale_toFetch = 'min';
        break;
    }
    _isLoading = true;
    _plotData =
        await API_SERVICES.fetchVSData(timeFrom, timeTo, selectedScale_toFetch);
    Timer(Duration(seconds: 1), () {
      setState(() {
        selectedPlotScale_rangeSelector = selectedScale_toFetch;
        print('selected scale ==> $selectedPlotScale_rangeSelector');
        _selectedRadioButton_rangeSelector = selectedScale;
        _vsScaleTimeType = selectedScale_toFetch;
        _showCustomRange = false;
        _isLoading = false;
        limitChartValue();
      });
    });
  }

  @override
  void initState() {
    _normalZone = widget.normalZone;
    _vsType = widget.vsType;
    _vsScaleTimeType = widget.vsScaleTimeType;
    _vsDefaultType = widget.vsDefaultType;
    _vsYAxisRange = widget.vsYAxisRange;
    _vsYAxisUnit = widget.vsYAxisUnit;
    _plotTitle = widget.plotTitle;
    _plotData = widget.plotData;

    _selectedRadioButton = 'min';
    _selectedRadioButton_rangeSelector = '1h';
    selectedPlotScale = 'min';
    selectedPlotScale_rangeSelector = 'min';

    _plotData =
        widget.plotData == null ? GLOBALS.FETCHED_RESPONSE : widget.plotData;
    _isLoading = false;

    temp_plot = [];
    // temp_plot = _plotData;
    super.initState();
  }

  limitChartValue() {
    len = _plotData.length;
    temp_plot = [];

    //limiting each visualization to 60 points only
    if (len > 61) {
      int batch = len ~/ 60;

      for (int i = 0; i < len; i++) {
        if (i % batch == 0) {
          temp_plot.add(_plotData[i]);
        }
        // _plotData = a;
      }

      print(temp_plot);
      print(temp_plot.length);
      setState(() {
        _plotData = temp_plot;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      //------------------------------------the container to contain plots---------------------------------
      children: [
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Center(
            child: Text(_plotTitle ?? "",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.textColor)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Column(
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
                                color: AppColors.textColor, fontSize: 12),
                          ),
                          Icon(
                            Icons.fiber_manual_record_rounded,
                            color:
                                isEmergencyDotOn ? Colors.green : Colors.grey,
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
                            style: TextStyle(
                                color: AppColors.textColor, fontSize: 12),
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
                                color:
                                    isMinMaxOn ? Colors.redAccent : Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Text(
                            "Min & Max",
                            style: TextStyle(
                                color: AppColors.textColor, fontSize: 12),
                          ),
                          Icon(
                            Icons.fiber_manual_record_rounded,
                            color: isMinMaxOn ? Colors.green : Colors.grey,
                            size: 10,
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _isLoading
                  ? CircularProgressIndicator()
                  : Container(
                      alignment: Alignment.center,
                      //padding: EdgeInsets.only(right: 20),
                      child: LineChart(
                        LineChartData(
                          extraLinesData: isRangeOnSpecificHour
                              ? ExtraLinesData(horizontalLines: [
                                  HorizontalLine(
                                    //y: isSwitched? 75:0,
                                    y: _normalZone.first * 1.0,
                                    color: Colors.redAccent,
                                    strokeWidth: 1,
                                  ),
                                  HorizontalLine(
                                    //y: isSwitched? 75:0,
                                    y: _normalZone.last * 1.0,
                                    color: Colors.redAccent,
                                    strokeWidth: 1,
                                  ),
                                ])
                              : ExtraLinesData(),
                          minX: 0,
                          maxX: (_plotData.length - 1) * 1.0,
                          minY: _vsYAxisRange.first,
                          maxY: _vsYAxisRange.last,
                          titlesData: FlTitlesData(
                            bottomTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 6,
                                getTitles: (value) {
                                  //print(value);
                                  String dateTimeString =
                                      _plotData[value.toInt()]["time"];

                                  String formattedDate = getLocalTime_XValue(
                                      dateTimeString, _vsScaleTimeType);
                                  //print(formattedDate);
                                  if (value.toInt() % (_plotData.length ~/ 3) ==
                                          0 ||
                                      value.toInt() == _plotData.length) {
                                    return formattedDate;
                                  } else {
                                    return '';
                                  }
                                }),
                            leftTitles: SideTitles(
                              showTitles: true,
                              getTitles: (value) {
                                //print("y: $value"); // y value
                                if (value.toInt() % (_vsYAxisRange.last ~/ 6) ==
                                        0 ||
                                    value.toInt() == _vsYAxisRange.last ||
                                    value.toInt() == _vsYAxisRange.first) {
                                  return value.toInt().toString() +
                                      '$_vsYAxisUnit';
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
                              spots: generateSpots(_plotData, _vsType,
                                  _vsDefaultType), // default type = mean, vsType = spo2
                              isCurved: true,
                              colors: gradientColors,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: isEmergencyDotOn
                                  ? FlDotData(
                                      show: true,
                                      checkToShowDot: (spot, belowBarData) {
                                        return spot.y < _normalZone.first ||
                                            spot.y > _normalZone.last;
                                      },
                                      getDotPainter: (spot, percent, barData,
                                              index) =>
                                          //FlDotCirclePainter(radius: 5, color: Colors.red.withOpacity(0.5)),
                                          FlDotCirclePainter(
                                              radius: 3,
                                              color: Colors.redAccent),
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
                              spots: generateSpots(_plotData, _vsType, "std",
                                  -1), // deviation negative
                              isCurved: true,
                              colors: [Colors.black54],
                              barWidth: 1,
                              isStrokeCapRound: true,
                              show: isStdDeviationOn24HoursGraph ? true : false,
                              dotData: FlDotData(show: false),
                              //barWidth: 1,
                            ),

                            LineChartBarData(
                              spots: generateSpots(_plotData, _vsType, "std",
                                  1), // deviation positive
                              isCurved: true,
                              colors: [Colors.black54],
                              barWidth: 1,
                              isStrokeCapRound: true,
                              show: isStdDeviationOn24HoursGraph ? true : false,
                              dotData: FlDotData(show: false),
                              //barWidth: 1,
                            ),
                            LineChartBarData(
                              spots: generateSpots(_plotData, _vsType, "min"),
                              isCurved: true,
                              colors: [Colors.yellowAccent],
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(show: false),
                              show: isMinMaxOn ? true : false,
                              //barWidth: 1,
                            ),
                            LineChartBarData(
                              spots: generateSpots(_plotData, _vsType, "max"),
                              isCurved: true,
                              colors: [Colors.deepOrangeAccent],
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(show: false),
                              show: isMinMaxOn ? true : false,
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
                    ),
            ],
          ),
        ),
        // RaisedButton(
        //   onPressed: () {
        //     setState(() {
        //       if (_showCustomRange == false) {
        //         _showCustomRange = true;
        //       } else {
        //         _showCustomRange = false;
        //       }
        //     });
        //   },
        //   textColor: Colors.black,
        //   //color: Colors.red,
        //   padding: const EdgeInsets.all(8.0),
        //   child: new Text(
        //     "Custom Range",
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio(
                value: '1h',
                groupValue: _selectedRadioButton_rangeSelector,
                onChanged: _radioButtonhandler_RangeSelector,
              ),
              Text(
                '1h',
                style: new TextStyle(fontSize: 12.0),
              ),
              Radio(
                value: '3h',
                groupValue: _selectedRadioButton_rangeSelector,
                onChanged: _radioButtonhandler_RangeSelector,
              ),
              Text(
                '3h',
                style: new TextStyle(fontSize: 12.0),
              ),
              Radio(
                value: '6h',
                groupValue: _selectedRadioButton_rangeSelector,
                onChanged: _radioButtonhandler_RangeSelector,
              ),
              Text(
                '6h',
                style: new TextStyle(fontSize: 12.0),
              ),
              Radio(
                value: '1d',
                groupValue: _selectedRadioButton_rangeSelector,
                onChanged: _radioButtonhandler_RangeSelector,
              ),
              Text(
                '1d',
                style: new TextStyle(fontSize: 12.0),
              ),
              // Radio(
              //   value: 'Custom',
              //   groupValue: _selectedRadioButton_rangeSelector,
              //   onChanged: _radioButtonhandler_RangeSelector,
              // ),
              // Text(
              //   'Custom',
              //   style: new TextStyle(fontSize: 12.0),
              // ),
            ],
          ),
        ),
        TextButton(
          onPressed: showDateSelectionDialogBox,
          child: Text(
            'Custom',
            style: TextStyle(
                color: AppColors.deccolor1,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
        ),
        // _showCustomRange ? showTitleDialog() : Container(),
      ],
    );
  }

  String getLocalTime_XValue(String dateTimeString, String vsResponseType) {
    switch (vsResponseType) {
      case 'min':
        String formattedDate = DateFormat()
            .add_jm()
            .format(DateTime.parse(dateTimeString).toLocal());
        return formattedDate;
      case 'hr':
        String formattedDate = DateFormat()
            .add_jm()
            .format(DateTime.parse(dateTimeString).toLocal());
        return formattedDate;
      case 'day':
        String formattedDate = DateFormat()
            .add_Md()
            .format(DateTime.parse(dateTimeString).toLocal());
        return formattedDate;
      case 'month':
        String formattedDate = DateFormat()
            .add_Md()
            .format(DateTime.parse(dateTimeString).toLocal());
        return formattedDate;
      default:
        String formattedDate = DateFormat()
            .add_jm()
            .format(DateTime.parse(dateTimeString).toLocal());
        return formattedDate;
    }
  }

  List<FlSpot> generateSpots(List data, String vsType, String vsScaleTimeType,
      [int deviationType]) {
    List<FlSpot> spots;
    if (deviationType != null) {
      spots = data.asMap().entries.map((e) {
        double default_vsValue =
            double.tryParse((e.value[vsType][vsScaleTimeType]).toString());
        double std_deviation = default_vsValue +
            ((deviationType) *
                double.tryParse((e.value[vsType]["std"]).toString()));
        double y = std_deviation;
        return FlSpot(e.key.toDouble(), y);
      }).toList();
    } else {
      spots = data.asMap().entries.map((e) {
        double y =
            double.tryParse((e.value[vsType][vsScaleTimeType]).toString());
        return FlSpot(e.key.toDouble(), y);
      }).toList();
    }

    return spots;
  }

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    //const Color(0xff02d39a),
  ];

  Future showDateSelectionDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Form(
              key: _keyDialogForm,
              child: Column(
                children: [
                  Column(children: [
                    // Text('FORM',
                    //     style:
                    //         TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Padding(
                      // padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),

                      child: DateTimePicker(
                        type: DateTimePickerType.dateTime,
                        use24HourFormat: false,
                        icon: Icon(Icons.event),
                        initialValue: DateTime.now().toString(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                        dateLabelText: 'From',
                        timeLabelText: "Hour",
                        onChanged: (val) {
                          DateTime selectedFromTime =
                              DateTime.parse(val).toUtc();
                          setState(() {
                            selected_FromTime = selectedFromTime;
                          });
                          print('selected from---------> $selected_FromTime');
                        },
                        // validator: (val) {
                        //   print(val);
                        //   return null;
                        // },
                        onSaved: (val) => print(val),
                      ),
                    ),
                    Padding(
                      // padding: const EdgeInsets.fromLTRB(50, 5, 50, 10),
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: DateTimePicker(
                        enabled: selected_FromTime != null ? true : false,
                        type: DateTimePickerType.dateTime,
                        use24HourFormat: false,
                        icon: Icon(Icons.event),
                        initialValue: DateTime.now().toString(),
                        firstDate: selected_FromTime ?? DateTime.now(),
                        lastDate: DateTime(2100),
                        dateLabelText: 'To',
                        timeLabelText: "Hour",
                        onChanged: (val) {
                          DateTime selectedToTime = DateTime.parse(val).toUtc();
                          setState(() {
                            selected_ToTime = selectedToTime;
                          });

                          print('selected from---------> $selected_ToTime');
                        },
                        validator: (val) {
                          print(val);
                          return null;
                        },
                        onSaved: (val) => print(val),
                      ),
                    ),
                  ]),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: [
                          Radio(
                            value: 'min',
                            groupValue: _selectedRadioButton,
                            onChanged: _radioButtonhandler,
                          ),
                          Text(
                            'minute',
                            style: new TextStyle(fontSize: 12.0),
                          ),
                          Radio(
                            value: 'hr',
                            groupValue: _selectedRadioButton,
                            onChanged: _radioButtonhandler,
                          ),
                          Text(
                            'hour',
                            style: new TextStyle(fontSize: 12.0),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 'day',
                            groupValue: _selectedRadioButton,
                            onChanged: _radioButtonhandler,
                          ),
                          Text(
                            'day',
                            style: new TextStyle(fontSize: 12.0),
                          ),
                          Radio(
                            value: 'month',
                            groupValue: _selectedRadioButton,
                            onChanged: _radioButtonhandler,
                          ),
                          Text(
                            'month',
                            style: new TextStyle(fontSize: 12.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () async {
                  if (_keyDialogForm.currentState.validate()) {
                    var temp_plotData = await API_SERVICES.fetchVSData(
                        selected_FromTime, selected_ToTime, selectedPlotScale);
                    Timer(Duration(seconds: 1), () {
                      setState(() {
                        _plotData = temp_plotData;
                        print(_plotData);
                        _showCustomRange = false;
                        _isLoading = false;
                      });
                    });
                    _keyDialogForm.currentState.save();
                    Navigator.pop(context);
                  }
                },
                child: Text('Filter'),
                color: Colors.blue,
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
            ],
          );
        });
  }
}
