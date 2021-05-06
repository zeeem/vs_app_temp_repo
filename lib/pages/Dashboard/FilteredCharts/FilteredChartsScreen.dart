import 'package:flutter/material.dart';
import 'package:vital_signs_app/elements/CustomAppBar.dart';

import '../../../core/configVS.dart';
import 'VS_chart_card_element.dart';

class FilteredCharts extends StatefulWidget {
  final int touchedIndex;
  final String touchedScale;
  final String touchedVSType;
  final List data_to_plot;
  final List long_data;
  final String timeOfData;
  final String vsYAxisUnit;

  const FilteredCharts(
      {Key key,
      this.touchedIndex,
      this.touchedScale,
      this.data_to_plot,
      this.long_data,
      //this.showAbnormalDots = false,
      this.touchedVSType = '',
      this.timeOfData,
      this.vsYAxisUnit})
      : super(key: key);

  @override
  _FilteredChartsState createState() => _FilteredChartsState();
}

class _FilteredChartsState extends State<FilteredCharts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 130, //no use of this fixed height
        turnOffBackButton: false,
        turnOffSettingsButton: true,
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(15),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(8),
          //   color: Colors.lightBlueAccent.withOpacity(.1),
          // ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/spo2_icon.png",
                      height: 40,
                      //width: 40,
                    ),
                    chart_card_element(
                      vsType: "spo2",
                      vsDefaultType: "mean",
                      vsScaleTimeType: "min",
                      vsYAxisUnit: "%",
                      vsYAxisRange: [91, 98],
                      plotData: GLOBALS.FETCHED_RESPONSE,
                      plotTitle: "",
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/hr_icon.png",
                      height: 40,
                      //width: 40,
                    ),
                    chart_card_element(
                      vsType: "hr",
                      vsDefaultType: "mean",
                      vsScaleTimeType: "min",
                      vsYAxisUnit: "",
                      vsYAxisRange: [70, 110],
                      plotData: GLOBALS.FETCHED_RESPONSE,
                      plotTitle: "",
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/rr_icon.png",
                      height: 40,
                      //width: 40,
                    ),
                    chart_card_element(
                      vsType: "rr",
                      vsDefaultType: "mean",
                      vsScaleTimeType: "min",
                      vsYAxisUnit: "",
                      vsYAxisRange: [14, 25],
                      plotData: GLOBALS.FETCHED_RESPONSE,
                      plotTitle: "",
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/temp_icon.png",
                      height: 40,
                      //width: 40,
                    ),
                    chart_card_element(
                      vsType: "temp",
                      vsDefaultType: "mean",
                      vsScaleTimeType: "min",
                      vsYAxisUnit: "°C",
                      vsYAxisRange: [36, 38],
                      showXAxis: true,
                      plotData: GLOBALS.FETCHED_RESPONSE,
                      plotTitle: "",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// bool isRangeOnSpecificHourSpo2 = false;
// bool isEmergencyDotOnSpo2 = false; //false
// bool isMinMaxOnSpo2 = false;
// bool isStdDeviationOn24HoursGraphSpo2 = false;
//
// bool isRangeOnSpecificHourHr = false;
// bool isEmergencyDotOnHr = false; //false
// bool isMinMaxOnHr = false;
// bool isStdDeviationOn24HoursGraphHr = false;
//
// bool isRangeOnSpecificHourTemp = false;
// bool isEmergencyDotOnTemp = false; //false
// bool isMinMaxOnTemp = false;
// bool isStdDeviationOn24HoursGraphTemp = false;
//
// bool isRangeOnSpecificHourRR = false;
// bool isEmergencyDotOnRR = false; //false
// bool isMinMaxOnRR = false;
// bool isStdDeviationOn24HoursGraphRR = false;
//
// class VSplotExample extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       title: 'ALL CHARTS',
//       slivers: [
//         _StickyHeaderGridSPO2(index: 0),
//         _StickyHeaderGridHR(index: 1),
//         _StickyHeaderGridTemp(index: 2),
//         _StickyHeaderGridRR(index: 3),
//         //_StickyHeaderGridHR(index: 4),
//       ],
//     );
//   }
// }
