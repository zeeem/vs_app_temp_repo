import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vital_signs_ui_template/pages/Dashboard/AbnormalVsBoard.dart';
import 'package:vital_signs_ui_template/pages/doctor_pages/HistoryPlots/PlotDataProcessing.dart';
import 'package:vital_signs_ui_template/pages/doctor_pages/HistoryPlots/StickyHeaderTest.dart';
import 'package:vital_signs_ui_template/pages/doctor_pages/HistoryPlots/plot_details.dart';
import 'package:vital_signs_ui_template/pages/doctor_pages/docVSPage.dart';

import 'vs_item.dart';

class alert_Card extends StatelessWidget {
  final int hr_val, spo2_val, rr_val;
  final double temp_val;
  final List<int> bp_val; //[hi,low]
  final DateTime measured_time;
  final Duration time_substract_val;
  final bool hr_alert, temp_alert, spo2_alert, rr_alert, bp_alert;
  final List vs_data;

  const alert_Card(
      {Key key,
      this.hr_val = 78,
      this.spo2_val = 98,
      this.rr_val = 16,
      this.temp_val = 37.5,
      this.bp_val = const [130, 90],
      this.measured_time,
      this.time_substract_val = const Duration(minutes: 0),
      this.hr_alert = false,
      this.temp_alert = false,
      this.spo2_alert = false,
      this.rr_alert = false,
      this.bp_alert = false,
      this.vs_data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List vsData_to_use = vs_data;
    if (vs_data == null) {
      vsData_to_use = tempStaticVals.historyplot;
    }
    int bp_MAP = (1 / 3 * bp_val[0] + 2 / 3 * bp_val[1]).truncate();
    return Container(
        child: Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
          child: Row(
            children: [
              // Text(
              //   'Measured at: ',
              //   style: TextStyle(
              //       fontSize: 16,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.black.withOpacity(.7)),
              // ),
              Text(
                getRandomTime(time_substract_val),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(.7)),
              ),
            ],
          ),
          alignment: Alignment.topLeft,
        ),
        Center(
          child: Wrap(
            runSpacing: 10,
            spacing: 12,
            children: <Widget>[
              vs_item(
                title: 'HR',
                valueToShow: '$hr_val',
                valueUnit: 'bpm',
                iconPath: 'assets/icons/hr_icon.png',
                press: () async {
                  // List whole_day_data_hr =
                  //     await initial_hourly_plot(vsData_to_use);

                  // List data_to_send = await processRange(
                  //     whole_day_data_hr.sublist(0, 600), 20); //30min data
                  //goto next page for details
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => PlotDetails(
                  //       touchedIndex: 0,
                  //       touchedScale: 'min', //hour,min,day
                  //       data_to_plot: data_to_send,
                  //       long_data: whole_day_data_hr,
                  //       showAbnormalDots: true,
                  //       touchedVSType: 'hr',
                  //     ),
                  //   ),
                  // );
                  navigateTo(context, VSplotExample());
                },
                isAbnormal: hr_alert,
              ),
              vs_item(
                title: 'TEMP',
                valueToShow: '$temp_val',
                valueUnit: '°C',
                iconPath: 'assets/icons/temp_icon2.png',
                press: () {
                  navigateTo(context, VSplotExample());
                },
                isAbnormal: temp_alert,
              ),
              vs_item(
                title: 'SPO2',
                valueToShow: '$spo2_val',
                valueUnit: '%',
                iconPath: 'assets/icons/spo2_icon.png',
                press: () async {
                  navigateTo(context, VSplotExample());

                  // List whole_day_data_hr =
                  //     await initial_hourly_plot(vsData_to_use);
                  //
                  // List data_to_send = await processRange(
                  //     whole_day_data_hr.sublist(0, 600), 20); //30min data
                  // //goto next page for details
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => PlotDetails(
                  //       touchedIndex: 0,
                  //       touchedScale: 'min', //hour,min,day
                  //       data_to_plot: data_to_send,
                  //       long_data: whole_day_data_hr,
                  //       showAbnormalDots: true,
                  //       touchedVSType: 'spo2',
                  //     ),
                  //   ),
                  // );
                },
                isAbnormal: spo2_alert,
              ),
              vs_item(
                title: 'RR',
                valueToShow: '$rr_val',
                valueUnit: 'rpm',
                iconPath: 'assets/icons/rr_icon.png',
                press: () {
                  navigateTo(context, VSplotExample());
                },
                isAbnormal: rr_alert,
              ),
              vs_item_bp(
                title: 'BP',
                valueToShow: '${bp_val[0]}/${bp_val[1]}',
                valueUnit: 'mmHg',
                iconPath: 'assets/icons/bp_icon.png',
                press: () {
                  navigateTo(context, VSplotExample());
                },
                maxWidth: 235,
                isAbnormal: bp_alert,
                bp_MAP_value: bp_MAP.toString(),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Divider()
      ],
    ));
  }

  String getRandomTime(Duration timeToSubtract) {
    return DateFormat.yMMMd()
        .add_jm()
        .format(DateTime.now().subtract(timeToSubtract))
        .toString();
  }

  // static List whole_day_data_hr;
  // static List hourlyDataToPlot_hr;

  List initial_hourly_plot(List data) {
    if (data == null) {
      data = tempStaticVals.historyplot;
    }
    int length = data.length;
    List sub_data = data.sublist(length - 28800, length);
    List whole_day_data_hr = sub_data;
    return whole_day_data_hr;
    // hourlyDataToPlot_hr = processRange(sub_data, 1200, "hr", 'median');
  }
}
