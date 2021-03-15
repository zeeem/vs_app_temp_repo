import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vital_signs_ui_template/core/configVS.dart';

class chart_card_element extends StatefulWidget {
  final String vsType;
  final String vsDefaultType;
  final String plotTitle;
  final List plotData;
  final List<double> vsYAxisRange;
  final String vsScaleTimeType; //min,hr,day,month
  final String vsYAxisUnit;
  final bool showXAxis;

  // final Image filteredChartsImage;
  // final List normalZone;
  // final String vsScaleTimeType;
  // final String vsDefaultType;

  // final String vsYAxisUnit;

  const chart_card_element({
    Key key,
    this.vsType = 'spo2',
    this.vsDefaultType = 'mean',
    this.plotTitle = "1 Hour Plot",
    this.plotData,
    this.vsYAxisRange = const [85, 102],
    this.vsScaleTimeType = 'min',
    this.vsYAxisUnit = "%",
    this.showXAxis = false,
  }) : super(key: key);
  @override
  _chart_card_elementState createState() => _chart_card_elementState();
}

class _chart_card_elementState extends State<chart_card_element> {
  String _vsType;
  String _plotTitle;
  String _vsDefaultType; //mean = average, med = median
  List _plotData;
  List<double> _vsYAxisRange;
  String _vsScaleTimeType; //min,hr,day,month
  String _vsYAxisUnit;
  bool _showXAxis;

  @override
  void initState() {
    _vsType = widget.vsType;
    _vsDefaultType = widget.vsDefaultType;
    _plotTitle = widget.plotTitle;
    _plotData = widget.plotData;
    _vsYAxisRange = widget.vsYAxisRange;
    _vsYAxisUnit = widget.vsYAxisUnit;
    _showXAxis = widget.showXAxis;

    _plotData =
        widget.plotData == null ? GLOBALS.FETCHED_RESPONSE : widget.plotData;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      //------------------------------------the container to contain plots---------------------------------
      children: [
        Container(
          alignment: Alignment.center,
          height: 100,
          //width: 300,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (_plotData.length - 1) * 1.0,
              minY: _vsYAxisRange.first,
              maxY: _vsYAxisRange.last,
              titlesData: FlTitlesData(
                bottomTitles: SideTitles(
                    showTitles: _showXAxis,
                    reservedSize: 25,
                    getTitles: (value) {
                      //print(value);
                      String dateTimeString = _plotData[value.toInt()]["time"];

                      String formattedDate =
                          getLocalTime_XValue(dateTimeString, _vsScaleTimeType);
                      //print(formattedDate);
                      if (value.toInt() % (_plotData.length ~/ 3) == 0 ||
                          value.toInt() == _plotData.length) {
                        return formattedDate;
                      } else {
                        return '';
                      }
                    }),
                leftTitles: SideTitles(
                  showTitles: true,
                  //reservedSize: 25,
                  getTitles: (value) {
                    //print("y: $value"); // y value
                    if (value.toInt() % (_vsYAxisRange.last ~/ 6) == 0 ||
                        //value.toInt() == _vsYAxisRange.last ||
                        value.toInt() == _vsYAxisRange.first) {
                      return value.toInt().toString() + '$_vsYAxisUnit';
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
                  dotData: FlDotData(
                    show: false,
                  ),
                  spots: generateSpots(_plotData, _vsType,
                      _vsDefaultType), // default type = mean, vsType = spo2
                  isCurved: true,
                  colors: gradientColors,
                  barWidth: 3,
                  isStrokeCapRound: true,

                  //barWidth: 1,
                  belowBarData: BarAreaData(
                      show: true,
                      colors: gradientColors
                          .map((color) => color.withOpacity(0.15))
                          .toList()),
                ),
              ],
            ),
          ),
        ),
      ],
    );
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

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    //const Color(0xff02d39a),
  ];
}
