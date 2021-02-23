import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:vital_signs_ui_template/elements/stickyHeader_common.dart';
import 'package:intl/intl.dart';

class StickyHeadertest extends StatefulWidget {
  @override
  _StickyHeadertestState createState() => _StickyHeadertestState();
}

class _StickyHeadertestState extends State<StickyHeadertest> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class VSplotExample extends StatelessWidget {
  const VSplotExample({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'ALL CHARTS',
      slivers: [
        _StickyHeaderGridSPO2(index: 0),
        _StickyHeaderGridHR(index: 1),
        _StickyHeaderGridHR(index: 2),
        _StickyHeaderGridHR(index: 3),
        _StickyHeaderGridHR(index: 4),
      ],
    );
  }
}

//----------SPO2 section---------------------------
class _StickyHeaderGridSPO2 extends StatelessWidget {
  const _StickyHeaderGridSPO2({
    Key key,
    this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: VSHeader(
        index: index,
        icon_location: "assets/icons/spo2_icon.png",
        title:
            "Oxygen Saturation", // change header title here eg. SPO2 HR RR BP
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
        delegate: SliverChildBuilderDelegate(
          (context, i) => GridTile(
            child: Card(
              child: Container(
                //------------------------------------the container to contain plots---------------------------------
                color: Colors.green,
              ),
            ),
          ),
          childCount:
              1, //change this to display multiple plots under one header
        ),
      ),
    );
  }
}

//------------------HR Section--------------

class _StickyHeaderGridHR extends StatelessWidget {
  const _StickyHeaderGridHR({
    Key key,
    this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: VSHeader(
          index: index,
          icon_location: "assets/icons/hr_icon.png",
          title: "Heart Rate"), // change header title here eg. SPO2 HR RR BP
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
        delegate: SliverChildBuilderDelegate(
          (context, i) => GridTile(
            child: Container(
              width: 335,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[100],
              ),
              child: Column(
                children: [
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
                        LineChart(
                          LineChartData(
                            extraLinesData: false
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
                                        .map((color) => color.withOpacity(0.15))
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
                                show: false ? true : false,
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
                                show: false ? true : false,
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
            ),
          ),
          childCount:
              1, //change this to display multiple plots under one header
        ),
      ),
    );
  }
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

List<Color> gradientColors = [
  const Color(0xff23b6e6),
  //const Color(0xff02d39a),
];
