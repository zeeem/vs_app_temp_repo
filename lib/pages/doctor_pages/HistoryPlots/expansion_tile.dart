// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:vital_signs_ui_template/core/consts.dart';
//
// class VS_expansion_tile extends StatelessWidget {
//   final bool isExpanded;
//   final bool isRangeOn1HourGraph_final;
//   final bool isStdDeviationOn1HourGraph_final;
//
//
//   const VS_expansion_tile({Key key, this.isExpanded = false, this.isRangeOn1HourGraph_final}) : super(key: key);
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     bool _isExpanded = isExpanded;
//     bool isRangeOn1HourGraph = isRangeOn1HourGraph_final;
//     bool isStdDeviationOn1HourGraph = isStdDeviationOn1HourGraph_final;
//     return  Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.white70.withOpacity(0.5),
//             spreadRadius: 3,
//             blurRadius: 5,
//             offset: Offset(0, 3), // changes position of shadow
//           ),
//         ],
//       ),
//       child: ExpansionTile(
//         initiallyExpanded: _isExpanded ?? false,
//         title: Text("Heart Rate",
//             style: TextStyle(
//                 fontSize: 20,
//                 fontWeight:
//                 _isExpanded ? FontWeight.bold : FontWeight.normal)),
//         leading: new Tab(
//             icon: new Image.asset("assets/icons/hr_icon.png",
//                 width: 32, height: 32)),
//         onExpansionChanged: ((newState) {
//           if (newState)
//              {
//               trailing:
//               Icon(Icons.keyboard_arrow_right);
//               _isExpanded = true;
//             }
//           else
//             {
//               trailing:
//               Icon(Icons.keyboard_arrow_down);
//               _isExpanded = false;
//             }
//
//         }),
//         children: <Widget>[
//           Column(
//             children: <Widget>[
//
//
//               Container(
//                 width: 335,
//                 //height: 300,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.grey[100],
//                 ),
//                 child: Column(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.only(top: 10),
//                       child: Center(
//                         child: Text("Last 1 Hour",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.textColor)),
//                       ),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         SizedBox(
//                           height: 25,
//                           child: FlatButton(
//                               onPressed: () {
//                                 if (isRangeOn1HourGraph)
//                                    {
//                                     isRangeOn1HourGraph = false;
//                                   }
//                                  else {
//
//                                     isRangeOn1HourGraph = true;
//
//                                 }
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.fromLTRB(
//                                     0, 0, 20, 0),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       "---- ",
//                                       style: TextStyle(
//                                           color: isRangeOn1HourGraph
//                                               ? Colors.redAccent
//                                               : Colors.grey,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 20),
//                                     ),
//                                     Text(
//                                       "Range",
//                                       style: TextStyle(
//                                           color: AppColors.textColor),
//                                     ),
//                                     Icon(
//                                       Icons.fiber_manual_record_rounded,
//                                       color: isRangeOn1HourGraph
//                                           ? Colors.green
//                                           : Colors.grey,
//                                       size: 10,
//                                     ),
//                                   ],
//                                 ),
//                               )),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         SizedBox(
//                           height: 25,
//                           child: FlatButton(
//                               onPressed: () {
//                                 if (isStdDeviationOn1HourGraph) {
//                                   setState(() {
//                                     isStdDeviationOn1HourGraph = false;
//                                   });
//                                 } else {
//                                   setState(() {
//                                     isStdDeviationOn1HourGraph = true;
//                                   });
//                                 }
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.fromLTRB(
//                                     0, 0, 20, 0),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       "---- ",
//                                       style: TextStyle(
//                                           color:
//                                           isStdDeviationOn1HourGraph
//                                               ? Colors.black54
//                                               : Colors.grey,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 20),
//                                     ),
//                                     Text(
//                                       "Standard Deviation",
//                                       style: TextStyle(
//                                           color: AppColors.textColor),
//                                     ),
//                                     Icon(
//                                       Icons.fiber_manual_record_rounded,
//                                       color: isStdDeviationOn1HourGraph
//                                           ? Colors.green
//                                           : Colors.grey,
//                                       size: 10,
//                                     ),
//                                   ],
//                                 ),
//                               )),
//                         ),
//                       ],
//                     ),
//                     LineChart(
//                       LineChartData(
//                         extraLinesData: isRangeOn1HourGraph
//                             ? ExtraLinesData(horizontalLines: [
//                           HorizontalLine(
//                             //y: isSwitched? 75:0,
//                             y: 75,
//                             color: Colors.redAccent,
//                             strokeWidth: 1,
//                           ),
//                           HorizontalLine(
//                             //y: isSwitched? 75:0,
//                             y: 85,
//                             color: Colors.redAccent,
//                             strokeWidth: 1,
//                           ),
//                         ])
//                             : ExtraLinesData(),
//                         minX: 0,
//                         maxX: maxX_range_hr,
//                         minY: 30,
//                         maxY: 150,
//                         titlesData: FlTitlesData(
//                           bottomTitles: SideTitles(
//                               showTitles: true,
//                               reservedSize: 6,
//                               getTitles: (value) {
//                                 if (value.toInt() % 15 == 0) {
//                                   return getTimes(value.toInt(), 'min');
//                                 } else {
//                                   return '';
//                                 }
//                                 // switch (value.toInt()) {
//                                 //   case 0:
//                                 //     return '1m';
//                                 //   case 15:
//                                 //     return '15m';
//                                 //   case 30:
//                                 //     return '30m';
//                                 //   case 45:
//                                 //     return '45m';
//                                 //   case 60:
//                                 //     return '1h';
//                                 //   default:
//                                 //     return '';
//                                 // }
//                               }),
//                           leftTitles: SideTitles(
//                             showTitles: true,
//                             getTitles: (value) {
//                               switch (value.toInt()) {
//                                 case 50:
//                                   return '50';
//                                 case 75:
//                                   return '75';
//                                 case 100:
//                                   return '100';
//                                 case 125:
//                                   return '125';
//                                 default:
//                                   return '';
//                               }
//                             },
//                           ),
//                         ),
//                         borderData: FlBorderData(show: false),
//                         gridData: FlGridData(show: false),
//                         lineBarsData: [
//                           //loadAsset(),
//                           LineChartBarData(
//                             spots: generateSpots(dataToPlot_hr,
//                                 dataIndex_to_show), // mean data, index 1 = avg
//                             isCurved: true,
//                             colors: gradientColors,
//                             barWidth: 3,
//                             isStrokeCapRound: true,
//                             dotData: FlDotData(show: false),
//                             //barWidth: 1,
//                             belowBarData: BarAreaData(
//                                 show: true,
//                                 colors: gradientColors
//                                     .map((color) =>
//                                     color.withOpacity(0.15))
//                                     .toList()),
//                           ),
//
//                           LineChartBarData(
//                             spots: generateSpots(
//                                 dataToPlot_hr, 3), // deviation negative
//                             isCurved: true,
//                             colors: [Colors.black54],
//                             barWidth: 1,
//                             isStrokeCapRound: true,
//                             show: isStdDeviationOn1HourGraph
//                                 ? true
//                                 : false,
//                             dotData: FlDotData(show: false),
//                             //barWidth: 1,
//                           ),
//
//                           LineChartBarData(
//                             spots: generateSpots(
//                                 dataToPlot_hr, 4), // deviation positive
//                             isCurved: true,
//                             colors: [Colors.black54],
//                             barWidth: 1,
//                             isStrokeCapRound: true,
//                             show: isStdDeviationOn1HourGraph
//                                 ? true
//                                 : false,
//                             dotData: FlDotData(show: false),
//                             //barWidth: 1,
//                           ),
//                         ],
//                         axisTitleData: FlAxisTitleData(
//                           bottomTitle: AxisTitle(
//                               showTitle: true,
//                               titleText: '',
//                               margin: 5),
//                           leftTitle: AxisTitle(
//                               showTitle: true,
//                               titleText: '',
//                               margin: 0),
//                         ),
//                         // lineTouchData: LineTouchData(getTouchedSpotIndicator:
//                         //     (LineChartBarData barData,
//                         //         List<int> spotIndexes) {
//                         //   return spotIndexes.map((spotIndex) {
//                         //     final FlSpot spot = barData.spots[spotIndex];
//                         //
//                         //     _touchedIndex = spotIndex;
//                         //     _touchedSpotValue = spot
//                         //         .x; //double (getting the x value or y value)
//                         //
//                         //     // if (spot.x == 0 || spot.x == 30 || spot.x == 29) {
//                         //     //   return null;
//                         //     // }
//                         //   }).toList();
//                         // }, touchCallback: (LineTouchResponse touchResponse) {
//                         //   if (touchResponse.touchInput is FlPanEnd ||
//                         //       touchResponse.touchInput is FlLongPressEnd) {
//                         //     //goto next page for details
//                         //     Navigator.push(
//                         //       context,
//                         //       MaterialPageRoute(
//                         //         builder: (context) => PlotDetails(
//                         //           touchedIndex: _touchedIndex,
//                         //           touchedScale: 'hr',
//                         //         ),
//                         //       ),
//                         //     );
//                         //     setState(() {
//                         //       print('touched index---> $_touchedIndex');
//                         //     });
//                         //   } else {
//                         //     print('wait');
//                         //   }
//                         // }),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               SizedBox(
//                 height: 20,
//               ),
//
//               Container(
//                 width: 335,
//                 //height: 300,
//
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.grey[100],
//                 ),
//                 child: Column(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.only(top: 10),
//                       child: Center(
//                         child: Text("Last 24 Hours",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.textColor)),
//                       ),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         SizedBox(
//                           height: 25,
//                           child: FlatButton(
//                               onPressed: () {
//                                 if (isRangeOn24HoursGraph) {
//                                   setState(() {
//                                     isRangeOn24HoursGraph = false;
//                                   });
//                                 } else {
//                                   setState(() {
//                                     isRangeOn24HoursGraph = true;
//                                   });
//                                 }
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.fromLTRB(
//                                     0, 0, 20, 0),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       "---- ",
//                                       style: TextStyle(
//                                           color: isRangeOn24HoursGraph
//                                               ? Colors.green
//                                               : Colors.grey,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 20),
//                                     ),
//                                     Text(
//                                       "Range",
//                                       style: TextStyle(
//                                           color: AppColors.textColor),
//                                     ),
//                                     Icon(
//                                       Icons.fiber_manual_record_rounded,
//                                       color: isRangeOn24HoursGraph
//                                           ? Colors.green
//                                           : Colors.grey,
//                                       size: 10,
//                                     ),
//                                   ],
//                                 ),
//                               )),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         SizedBox(
//                           height: 25,
//                           child: FlatButton(
//                               onPressed: () {
//                                 if (isStdDeviationOn24HoursGraph) {
//                                   setState(() {
//                                     isStdDeviationOn24HoursGraph =
//                                     false;
//                                   });
//                                 } else {
//                                   setState(() {
//                                     isStdDeviationOn24HoursGraph = true;
//                                   });
//                                 }
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.fromLTRB(
//                                     0, 0, 20, 0),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       "---- ",
//                                       style: TextStyle(
//                                           color:
//                                           isStdDeviationOn24HoursGraph
//                                               ? Colors.black54
//                                               : Colors.grey,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 20),
//                                     ),
//                                     Text(
//                                       "Standard Deviation",
//                                       style: TextStyle(
//                                           color: AppColors.textColor),
//                                     ),
//                                     Icon(
//                                       Icons.fiber_manual_record_rounded,
//                                       color:
//                                       isStdDeviationOn24HoursGraph
//                                           ? Colors.green
//                                           : Colors.grey,
//                                       size: 10,
//                                     ),
//                                   ],
//                                 ),
//                               )),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         SizedBox(
//                           height: 25,
//                           child: FlatButton(
//                               onPressed: () {
//                                 if (isMinMaxOn24HoursGraph) {
//                                   setState(() {
//                                     isMinMaxOn24HoursGraph = false;
//                                   });
//                                 } else {
//                                   setState(() {
//                                     isMinMaxOn24HoursGraph = true;
//                                   });
//                                 }
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.fromLTRB(
//                                     0, 0, 20, 0),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       "--",
//                                       style: TextStyle(
//                                           color: isMinMaxOn24HoursGraph
//                                               ? Colors.orangeAccent
//                                               : Colors.grey,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 20),
//                                     ),
//                                     Text(
//                                       "-- ",
//                                       style: TextStyle(
//                                           color: isMinMaxOn24HoursGraph
//                                               ? Colors.yellowAccent
//                                               : Colors.grey,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 20),
//                                     ),
//                                     Text(
//                                       "Min Max Line",
//                                       style: TextStyle(
//                                           color: AppColors.textColor),
//                                     ),
//                                     Icon(
//                                       Icons.fiber_manual_record_rounded,
//                                       color: isMinMaxOn24HoursGraph
//                                           ? Colors.green
//                                           : Colors.grey,
//                                       size: 10,
//                                     ),
//                                   ],
//                                 ),
//                               )),
//                         ),
//                       ],
//                     ),
//                     LineChart(
//                       LineChartData(
//                         extraLinesData: isRangeOn24HoursGraph
//                             ? ExtraLinesData(horizontalLines: [
//                           HorizontalLine(
//                             y: 75,
//                             color: Colors.green,
//                             strokeWidth: 1,
//                           ),
//                           HorizontalLine(
//                             //y: isSwitched? 75:0,
//                             y: 85,
//                             color: Colors.green,
//                             strokeWidth: 1,
//                           ),
//                         ])
//                             : ExtraLinesData(),
//                         minX: 0,
//                         maxX: maxX_range_hourly_hr,
//                         minY: 30,
//                         maxY: 150,
//                         titlesData: FlTitlesData(
//                           bottomTitles: SideTitles(
//                               showTitles: true,
//                               reservedSize: 6,
//                               getTitles: (value) {
//                                 if (value.toInt() % 6 == 0) {
//                                   return getTimes(
//                                       value.toInt(), 'hour');
//                                 } else {
//                                   return '';
//                                 }
//                               }),
//                           leftTitles: SideTitles(
//                             showTitles: true,
//                             getTitles: (value) {
//                               switch (value.toInt()) {
//                                 case 50:
//                                   return '50';
//                                 case 75:
//                                   return '75';
//                                 case 100:
//                                   return '100';
//                                 case 125:
//                                   return '125';
//                                 default:
//                                   return '';
//                               }
//                             },
//                           ),
//                         ),
//                         borderData: FlBorderData(show: false),
//                         gridData: FlGridData(show: false),
//                         lineBarsData: [
//                           LineChartBarData(
//                             spots: generateHourlySpots(1),
//                             isCurved: true,
//                             colors: gradientColors,
//                             barWidth: 3,
//                             isStrokeCapRound: true,
//                             dotData: FlDotData(show: false),
//                             //barWidth: 1,
//                             belowBarData: BarAreaData(
//                                 show: true,
//                                 colors: gradientColors
//                                     .map((color) =>
//                                     color.withOpacity(0.15))
//                                     .toList()),
//                           ),
//                           LineChartBarData(
//                             spots: generateHourlySpots(0),
//                             isCurved: true,
//                             colors: [Colors.yellowAccent],
//                             barWidth: 3,
//                             isStrokeCapRound: true,
//                             dotData: FlDotData(show: false),
//                             show: isMinMaxOn24HoursGraph ? true : false,
//                             //barWidth: 1,
//                           ),
//                           LineChartBarData(
//                             spots: generateHourlySpots(2),
//                             isCurved: true,
//                             colors: [Colors.deepOrangeAccent],
//                             barWidth: 3,
//                             isStrokeCapRound: true,
//                             dotData: FlDotData(show: false),
//                             show: isMinMaxOn24HoursGraph ? true : false,
//                             //barWidth: 1,
//                           ),
//                           LineChartBarData(
//                             spots: generateHourlySpots(3),
//                             isCurved: true,
//                             colors: [Colors.grey],
//                             barWidth: 1,
//                             isStrokeCapRound: true,
//                             dotData: FlDotData(show: false),
//                             show: isStdDeviationOn24HoursGraph
//                                 ? true
//                                 : false,
//                             //barWidth: 1,
//                           ),
//                           LineChartBarData(
//                             spots: generateHourlySpots(4),
//                             isCurved: true,
//                             colors: [Colors.grey],
//                             barWidth: 1,
//                             isStrokeCapRound: true,
//                             dotData: FlDotData(show: false),
//                             show: isStdDeviationOn24HoursGraph
//                                 ? true
//                                 : false,
//                             //barWidth: 1,
//                           ),
//                         ],
//                         axisTitleData: FlAxisTitleData(
//                           bottomTitle: AxisTitle(
//                               showTitle: true,
//                               titleText: '',
//                               margin: 5),
//                           leftTitle: AxisTitle(
//                               showTitle: true,
//                               titleText: '',
//                               margin: 0),
//                         ),
//                         lineTouchData: LineTouchData(
//                             getTouchedSpotIndicator:
//                                 (LineChartBarData barData,
//                                 List<int> spotIndexes) {
//                               return spotIndexes.map((spotIndex) {
//                                 final FlSpot spot =
//                                 barData.spots[spotIndex];
//
//                                 _touchedIndex = spotIndex;
//                                 _touchedSpotValue = spot
//                                     .x; //double (getting the x value or y value)
//
//                                 // if (spot.x == 0 || spot.x == 30 || spot.x == 29) {
//                                 //   return null;
//                                 // }
//                               }).toList();
//                             }, touchCallback:
//                             (LineTouchResponse touchResponse) {
//                           if (touchResponse.touchInput is FlPanEnd ||
//                               touchResponse.touchInput
//                               is FlLongPressEnd) {
//                             List data_to_send = processRange(
//                                 whole_day_data_hr.sublist(
//                                     (_touchedIndex) * 1200,
//                                     (_touchedIndex * 1200) + 1200),
//                                 20);
//                             //goto next page for details
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => PlotDetails(
//                                   touchedIndex: _touchedIndex,
//                                   touchedScale: 'hour', //hour,min,day
//                                   data_to_plot: data_to_send,
//                                   long_data: data,
//                                 ),
//                               ),
//                             );
//                             setState(() {
//                               print('touched index---> $_touchedIndex');
//                             });
//                           } else {
//                             print('wait');
//                           }
//                         }),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Container(
//               //   padding: EdgeInsets.all(20),
//               //   child: AspectRatio(
//               //     aspectRatio: 1,
//               //     child: Card(
//               //       elevation: 0,
//               //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//               //       color: Colors.grey[100],
//               //       child: Padding(
//               //         padding: const EdgeInsets.all(16),
//               //         child: Column(
//               //           crossAxisAlignment: CrossAxisAlignment.stretch,
//               //           mainAxisAlignment: MainAxisAlignment.start,
//               //           mainAxisSize: MainAxisSize.max,
//               //           children: <Widget>[
//               //
//               //             Expanded(
//               //               child: Padding(
//               //                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               //                 child: Column(
//               //                   children: [
//               //                     Container(
//               //                       padding: EdgeInsets.only(bottom: 10),
//               //                       child: Center(
//               //                         child: Text("Last 3 Weeks", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textColor)),
//               //                       ),
//               //                     ),
//               //                     Expanded(
//               //                       child: BarChart(
//               //                         BarChartData(
//               //                           maxY: 20,
//               //                           barTouchData: BarTouchData(
//               //                               touchTooltipData: BarTouchTooltipData(
//               //                                 tooltipBgColor: Colors.grey,
//               //                                 getTooltipItem: (_a, _b, _c, _d) => null,
//               //                               ),
//               //                               touchCallback: (response) {
//               //                                 if (response.spot == null) {
//               //                                   setState(() {
//               //                                     touchedGroupIndex = -1;
//               //                                     showingBarGroups = List.of(rawBarGroups);
//               //                                   });
//               //                                   return;
//               //                                 }
//               //
//               //                                 touchedGroupIndex = response.spot.touchedBarGroupIndex;
//               //
//               //                                 setState(() {
//               //                                   if (response.touchInput is FlLongPressEnd ||
//               //                                       response.touchInput is FlPanEnd) {
//               //                                     touchedGroupIndex = -1;
//               //                                     showingBarGroups = List.of(rawBarGroups);
//               //                                   } else {
//               //                                     showingBarGroups = List.of(rawBarGroups);
//               //                                     if (touchedGroupIndex != -1) {
//               //                                       double sum = 0;
//               //                                       for (BarChartRodData rod
//               //                                       in showingBarGroups[touchedGroupIndex].barRods) {
//               //                                         sum += rod.y;
//               //                                       }
//               //                                       final avg =
//               //                                           sum / showingBarGroups[touchedGroupIndex].barRods.length;
//               //
//               //                                       showingBarGroups[touchedGroupIndex] =
//               //                                           showingBarGroups[touchedGroupIndex].copyWith(
//               //                                             barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
//               //                                               return rod.copyWith(y: avg);
//               //                                             }).toList(),
//               //                                           );
//               //                                     }
//               //                                   }
//               //                                 });
//               //                               }),
//               //                           titlesData: FlTitlesData(
//               //                             show: true,
//               //                             bottomTitles: SideTitles(
//               //                               showTitles: true,
//               //                               // getTextStyles: (value) => const TextStyle(
//               //                               //     color: Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14),
//               //                               margin: 20,
//               //                               getTitles: (double value) {
//               //                                 switch (value.toInt()) {
//               //                                   case 0:
//               //                                     return 'Week 1';
//               //                                   case 1:
//               //                                     return 'Week 2';
//               //                                   case 2:
//               //                                     return 'Week 3';
//               //                                   case 3:
//               //                                     return 'Week 4';
//               //                                 // case 4:
//               //                                 //   return 'Fr';
//               //                                 // case 5:
//               //                                 //   return 'St';
//               //                                 // case 6:
//               //                                 //   return 'Sn';
//               //                                   default:
//               //                                     return '';
//               //                                 }
//               //                               },
//               //                             ),
//               //                             leftTitles: SideTitles(
//               //                               showTitles: true,
//               //                               // getTextStyles: (value) => const TextStyle(
//               //                               //     color: Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14),
//               //                               margin: 20,
//               //                               reservedSize: 14,
//               //                               getTitles: (value) {
//               //                                 if (value == 0) {
//               //                                   return '0';
//               //                                 } else if (value == 10) {
//               //                                   return '75';
//               //                                 } else if (value == 19) {
//               //                                   return '100';
//               //                                 } else {
//               //                                   return '';
//               //                                 }
//               //                               },
//               //                             ),
//               //                           ),
//               //                           borderData: FlBorderData(
//               //                             show: false,
//               //                           ),
//               //                           barGroups: showingBarGroups,
//               //                         ),
//               //                       ),
//               //                     ),
//               //                   ],
//               //                 ),
//               //               ),
//               //             ),
//               //             const SizedBox(
//               //               height: 12,
//               //             ),
//               //           ],
//               //         ),
//               //       ),
//               //     ),
//               //
//               //   ),
//               // ),
//
//               SizedBox(
//                 height: 20,
//               ),
//               Container(
//                 width: 335,
//                 //height: 300,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.grey[100],
//                 ),
//                 child: Column(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.only(top: 10),
//                       child: Center(
//                         child: Text("Last 7 Days Data",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.textColor)),
//                       ),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         SizedBox(
//                           height: 25,
//                           child: FlatButton(
//                               onPressed: () {
//                                 if (isRangeOn3WeeksGraph) {
//                                   setState(() {
//                                     isRangeOn3WeeksGraph = false;
//                                   });
//                                 } else {
//                                   setState(() {
//                                     isRangeOn3WeeksGraph = true;
//                                   });
//                                 }
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.fromLTRB(
//                                     0, 0, 20, 0),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       "---- ",
//                                       style: TextStyle(
//                                           color: isRangeOn3WeeksGraph
//                                               ? Colors.redAccent
//                                               : Colors.grey,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 20),
//                                     ),
//                                     Text(
//                                       "Range",
//                                       style: TextStyle(
//                                           color: AppColors.textColor),
//                                     ),
//                                     Icon(
//                                       Icons.fiber_manual_record_rounded,
//                                       color: isRangeOn3WeeksGraph
//                                           ? Colors.green
//                                           : Colors.grey,
//                                       size: 10,
//                                     ),
//                                   ],
//                                 ),
//                               )),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         SizedBox(
//                           height: 25,
//                           child: FlatButton(
//                               onPressed: () {
//                                 if (isMinMaxOn3WeeksGraph) {
//                                   setState(() {
//                                     isMinMaxOn3WeeksGraph = false;
//                                   });
//                                 } else {
//                                   setState(() {
//                                     isMinMaxOn3WeeksGraph = true;
//                                   });
//                                 }
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.fromLTRB(
//                                     0, 0, 20, 0),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       "--",
//                                       style: TextStyle(
//                                           color: isMinMaxOn3WeeksGraph
//                                               ? Colors.orangeAccent
//                                               : Colors.grey,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 20),
//                                     ),
//                                     Text(
//                                       "-- ",
//                                       style: TextStyle(
//                                           color: isMinMaxOn3WeeksGraph
//                                               ? Colors.yellowAccent
//                                               : Colors.grey,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 20),
//                                     ),
//                                     Text(
//                                       "Min Max Line",
//                                       style: TextStyle(
//                                           color: AppColors.textColor),
//                                     ),
//                                     Icon(
//                                       Icons.fiber_manual_record_rounded,
//                                       color: isMinMaxOn3WeeksGraph
//                                           ? Colors.green
//                                           : Colors.grey,
//                                       size: 10,
//                                     ),
//                                   ],
//                                 ),
//                               )),
//                         ),
//                       ],
//                     ),
//                     LineChart(
//                       LineChartData(
//                         extraLinesData: isRangeOn3WeeksGraph
//                             ? ExtraLinesData(horizontalLines: [
//                           HorizontalLine(
//                             //y: isSwitched? 75:0,
//                             y: 75,
//                             color: Colors.redAccent,
//                             strokeWidth: 1,
//                           ),
//                           HorizontalLine(
//                             //y: isSwitched? 75:0,
//                             y: 85,
//                             color: Colors.redAccent,
//                             strokeWidth: 1,
//                           ),
//                         ])
//                             : ExtraLinesData(),
//                         minX: 0,
//                         maxX: 6,
//                         minY: 30,
//                         maxY: 150,
//                         titlesData: FlTitlesData(
//                           bottomTitles: SideTitles(
//                               showTitles: true,
//                               reservedSize: 6,
//                               getTitles: (value) {
//                                 if (value.toInt() % 1 == 0) {
//                                   return getTimes(value.toInt(), 'day');
//                                 } else {
//                                   return '';
//                                 }
//                               }),
//                           leftTitles: SideTitles(
//                             showTitles: true,
//                             getTitles: (value) {
//                               switch (value.toInt()) {
//                                 case 50:
//                                   return '50';
//                                 case 75:
//                                   return '75';
//                                 case 100:
//                                   return '100';
//                                 case 125:
//                                   return '125';
//                                 default:
//                                   return '';
//                               }
//                             },
//                           ),
//                         ),
//                         borderData: FlBorderData(show: false),
//                         gridData: FlGridData(show: false),
//                         lineBarsData: [
//                           //loadAsset(),
//                           LineChartBarData(
//                             spots: [
//                               FlSpot(0, 75),
//                               FlSpot(1, 85),
//                               FlSpot(2, 81),
//                               FlSpot(3, 75),
//                               FlSpot(4, 85),
//                               FlSpot(5, 81),
//                               FlSpot(6, 81)
//                             ], // mean data, index 1 = avg
//                             isCurved: false,
//                             colors: gradientColors,
//                             barWidth: 3,
//                             isStrokeCapRound: true,
//                             dotData: FlDotData(show: true),
//                             //barWidth: 1,
//                             belowBarData: BarAreaData(
//                                 show: true,
//                                 colors: gradientColors
//                                     .map((color) =>
//                                     color.withOpacity(0.15))
//                                     .toList()),
//                           ),
//
//                           LineChartBarData(
//                             spots: [
//                               FlSpot(0, 95),
//                               FlSpot(1, 110),
//                               FlSpot(2, 99),
//                               FlSpot(3, 95),
//                               FlSpot(4, 110),
//                               FlSpot(5, 99),
//                               FlSpot(6, 110)
//                             ],
//                             isCurved: false,
//                             colors: [Colors.deepOrangeAccent],
//                             barWidth: 2,
//                             isStrokeCapRound: true,
//                             dotData: FlDotData(show: false),
//                             show: isMinMaxOn3WeeksGraph ? true : false,
//                             //barWidth: 1,
//                           ),
//
//                           LineChartBarData(
//                             spots: [
//                               FlSpot(0, 70),
//                               FlSpot(1, 77),
//                               FlSpot(2, 69),
//                               FlSpot(3, 65),
//                               FlSpot(4, 77),
//                               FlSpot(5, 69),
//                               FlSpot(6, 69)
//                             ],
//                             isCurved: false,
//                             colors: [Colors.yellowAccent],
//                             barWidth: 2,
//                             isStrokeCapRound: true,
//                             dotData: FlDotData(show: false),
//                             show: isMinMaxOn3WeeksGraph ? true : false,
//                             //barWidth: 1,
//                           ),
//
//                           // LineChartBarData(
//                           //   spots: generateSpots(dataToPlot, 3),    // deviation negative
//                           //   isCurved: true,
//                           //   colors: [Colors.black54],
//                           //   barWidth: 1,
//                           //   isStrokeCapRound: true,
//                           //   show: isStdDeviationOnFirstGraph? true: false,
//                           //   dotData: FlDotData(show: false),
//                           //   //barWidth: 1,
//                           //
//                           // ),
//                           //
//                           // LineChartBarData(
//                           //   spots: generateSpots(dataToPlot, 4),    // deviation positive
//                           //   isCurved: true,
//                           //   colors: [Colors.black54],
//                           //   barWidth: 1,
//                           //   isStrokeCapRound: true,
//                           //   show: isStdDeviationOnFirstGraph? true: false,
//                           //   dotData: FlDotData(show: false),
//                           //   //barWidth: 1,
//                           //
//                           // ),
//                         ],
//                         axisTitleData: FlAxisTitleData(
//                           bottomTitle: AxisTitle(
//                               showTitle: true,
//                               titleText: '',
//                               margin: 5),
//                           leftTitle: AxisTitle(
//                               showTitle: true,
//                               titleText: '',
//                               margin: 0),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//
//   }
// }
