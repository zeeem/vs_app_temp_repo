import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';
import 'package:vital_signs_ui_template/elements/API_services.dart';
import 'package:vital_signs_ui_template/elements/base_plot_element.dart';
import 'package:vital_signs_ui_template/elements/stickyHeader_common.dart';

import '../../../core/configVS.dart';

class StickyHeadertest extends StatefulWidget {
  final int touchedIndex;
  final String touchedScale;
  final String touchedVSType;
  final List data_to_plot;
  final List long_data;
  final String timeOfData;

  const StickyHeadertest(
      {Key key,
      this.touchedIndex,
      this.touchedScale,
      this.data_to_plot,
      this.long_data,
      //this.showAbnormalDots = false,
      this.touchedVSType = '',
      this.timeOfData})
      : super(key: key);

  @override
  _StickyHeadertestState createState() => _StickyHeadertestState();
}

class _StickyHeadertestState extends State<StickyHeadertest> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

bool isRangeOnSpecificHourSpo2 = false;
bool isEmergencyDotOnSpo2 = false; //false
bool isMinMaxOnSpo2 = false;
bool isStdDeviationOn24HoursGraphSpo2 = false;

bool isRangeOnSpecificHourHr = false;
bool isEmergencyDotOnHr = false; //false
bool isMinMaxOnHr = false;
bool isStdDeviationOn24HoursGraphHr = false;

bool isRangeOnSpecificHourTemp = false;
bool isEmergencyDotOnTemp = false; //false
bool isMinMaxOnTemp = false;
bool isStdDeviationOn24HoursGraphTemp = false;

bool isRangeOnSpecificHourRR = false;
bool isEmergencyDotOnRR = false; //false
bool isMinMaxOnRR = false;
bool isStdDeviationOn24HoursGraphRR = false;

class VSplotExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onVerticalDragDown: (var i) {
      //   print('dragged');
      //   print(i);
      // },
      child: AppScaffold(
        title: 'ALL CHARTS',
        slivers: [
          _StickyHeaderGridSPO2(index: 0),
          _StickyHeaderGridHR(index: 1),
          _StickyHeaderGridTemp(index: 2),
          _StickyHeaderGridRR(index: 3),
          //_StickyHeaderGridHR(index: 4),
        ],
      ),
    );
  }
}

//----------SPO2 section---------------------------
class _StickyHeaderGridSPO2 extends StatefulWidget {
  const _StickyHeaderGridSPO2({
    Key key,
    this.index,
  }) : super(key: key);

  final int index;

  @override
  __StickyHeaderGridSPO2State createState() => __StickyHeaderGridSPO2State();
}

class __StickyHeaderGridSPO2State extends State<_StickyHeaderGridSPO2> {
  @override
  void initState() {
    DateTime timeFrom = DateTime.parse("2021-03-05 20:00:00.000Z");
    DateTime timeTo;
    timeTo = timeFrom.add(Duration(hours: 1));

    // API_SERVICES.fetchVSData(timeFrom, timeTo, "min");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: VSHeader(
        index: widget.index,
        icon_location: "assets/icons/spo2_icon.png",
        title:
            "Oxygen Saturation", // change header title here eg. SPO2 HR RR BP
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: MediaQuery.of(context).size.height,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
          childAspectRatio: .6,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => GridTile(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
              child: base_plot_element(
                normalZone: [91, 100],
                vsType: "spo2",
                vsDefaultType: "mean",
                vsScaleTimeType: "min",
                vsYAxisRange: [85, 100],
                vsYAxisUnit: "%",
                plotData: GLOBALS.FETCHED_RESPONSE,
                plotTitle: "",
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

class _StickyHeaderGridHR extends StatefulWidget {
  const _StickyHeaderGridHR({
    Key key,
    this.index,
  }) : super(key: key);

  final int index;

  @override
  __StickyHeaderGridHRState createState() => __StickyHeaderGridHRState();
}

class __StickyHeaderGridHRState extends State<_StickyHeaderGridHR> {
  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: VSHeader(
          index: widget.index,
          icon_location: "assets/icons/hr_icon.png",
          title: "Heart Rate"), // change header title here eg. SPO2 HR RR BP
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: MediaQuery.of(context).size.height,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
          childAspectRatio: .6,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => GridTile(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
              child: base_plot_element(
                normalZone: [60, 100],
                vsType: "hr",
                vsDefaultType: "mean",
                vsScaleTimeType: "min",
                vsYAxisRange: [50, 120],
                vsYAxisUnit: "",
                plotData: GLOBALS.FETCHED_RESPONSE,
                plotTitle: "",
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

//------------------------------------------Temp Section-------------------------------------------

class _StickyHeaderGridTemp extends StatefulWidget {
  const _StickyHeaderGridTemp({
    Key key,
    this.index,
  }) : super(key: key);

  final int index;

  @override
  __StickyHeaderGridTempState createState() => __StickyHeaderGridTempState();
}

class __StickyHeaderGridTempState extends State<_StickyHeaderGridTemp> {
  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: VSHeader(
          index: widget.index,
          icon_location: "assets/icons/temp_icon.png",
          title: "Temperature"), // change header title here eg. SPO2 HR RR BP
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: MediaQuery.of(context).size.height,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
          childAspectRatio: .6,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => GridTile(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
              child: base_plot_element(
                normalZone: [37, 37],
                vsType: "temp",
                vsDefaultType: "mean",
                vsScaleTimeType: "min",
                vsYAxisRange: [35, 40],
                vsYAxisUnit: "°C",
                plotData: GLOBALS.FETCHED_RESPONSE,
                plotTitle: "",
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

//--------------------------------------RR Section------------------------------------------------

class _StickyHeaderGridRR extends StatefulWidget {
  const _StickyHeaderGridRR({
    Key key,
    this.index,
  }) : super(key: key);

  final int index;

  @override
  __StickyHeaderGridRRState createState() => __StickyHeaderGridRRState();
}

class __StickyHeaderGridRRState extends State<_StickyHeaderGridRR> {
  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: VSHeader(
          index: widget.index,
          icon_location: "assets/icons/rr_icon.png",
          title:
              "Respiratory Rate"), // change header title here eg. SPO2 HR RR BP
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: MediaQuery.of(context).size.height,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
          childAspectRatio: .6,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => GridTile(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
              child: base_plot_element(
                normalZone: [12, 16],
                vsType: "rr",
                vsDefaultType: "mean",
                vsScaleTimeType: "min",
                vsYAxisRange: [8, 25],
                vsYAxisUnit: "",
                plotData: GLOBALS.FETCHED_RESPONSE,
                plotTitle: "",
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
