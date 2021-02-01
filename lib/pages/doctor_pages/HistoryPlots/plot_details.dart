import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';

import '../../../core/consts.dart';

class PlotDetails extends StatefulWidget {
  final int touchedIndex;
  final String touchedScale;
  final List data_to_plot;

  const PlotDetails({Key key, this.touchedIndex, this.touchedScale, this.data_to_plot})
      : super(key: key);

  @override
  _PlotDetailsState createState() => _PlotDetailsState();
}

class _PlotDetailsState extends State<PlotDetails> {
  int _touchedIndex;
  String _touchedScale;
  List _data_to_plot;
  double _maxX_range;


  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    //const Color(0xff02d39a),
  ];

  @override
  void initState() {
    _touchedIndex = widget.touchedIndex;
    _touchedScale = widget.touchedScale;
    _data_to_plot = widget.data_to_plot;
    _maxX_range = _data_to_plot.length*1.0;
    super.initState();
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
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Center(
              child: Text("Data for hour: $_touchedIndex", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textColor)),
            ),
          ),
          Container(


            width: 335,
            height: 300,


            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[100],
            ),
            child: LineChart(
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
                maxX: _maxX_range,
                minY: 30,
                maxY: 150,
                titlesData: FlTitlesData(
                  bottomTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 6,
                      getTitles: (value) {
                        switch (value.toInt()) {
                          case 0:
                            return '0';
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
                    spots: generateHourlySpots(_data_to_plot, 1),
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
          ),
        ],
      ),
    );
  }

  List<FlSpot> generateHourlySpots(List data_to_plot, int index) {
    List<FlSpot> spots = data_to_plot.asMap().entries.map((e) {
      double y = double.tryParse(e.value[index].toString());
      return FlSpot(e.key.toDouble(), y);
    }).toList();

    return spots;
  }
}
