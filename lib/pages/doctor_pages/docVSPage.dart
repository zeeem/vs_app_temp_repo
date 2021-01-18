import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading/indicator/line_scale_indicator.dart';
import 'package:loading/loading.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';
import 'package:vital_signs_ui_template/elements/User.dart';
import 'package:vital_signs_ui_template/elements/info_card.dart';
import 'package:vital_signs_ui_template/pages/doctor_pages/HistoryPlot.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class docVsVisualizerPage extends StatefulWidget {
  final User clicked_user;
  final String doc_hr;
  final String doc_rr;
  final String doc_spo2;
  final String doc_temp;

  const docVsVisualizerPage(
      {Key key,
      this.clicked_user,
      this.doc_hr = '78',
      this.doc_rr = '16',
      this.doc_spo2 = '99',
      this.doc_temp = '37'})
      : super(key: key);

  @override
  _docVsVisualizerPageState createState() => _docVsVisualizerPageState();
}

class _docVsVisualizerPageState extends State<docVsVisualizerPage> {
  List<dynamic> hitoryData = [];

  loadAsset() async {
    final myData = await rootBundle.loadString(
        "assets/csv/mcgill_ble_rawdata_2021-01-04_142115.986889.csv");

    //print(myData);
    List<dynamic> csvTable = CsvToListConverter().convert(myData);
    print(csvTable[0].last);

    hitoryData = csvTable;
  }

  @override
  void initState() {
    loadAsset();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: CustomAppBar(
            turnOffBackButton: false,
            turnOffSettingsButton: true,
            height: 130, //no use of this fixed height
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0.0),
                        child: Text(
                          widget.clicked_user.name,
                          style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(.7)),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 0, top: 20, right: 0, bottom: 20),
                            width: double.infinity,
                            decoration: BoxDecoration(
//                      color: AppColors.mainColor.withOpacity(0.03),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(50),
                                bottomRight: Radius.circular(50),
                              ),
                            ),
                            child: Center(
                              child: Center(
                                child: Wrap(
                                  runSpacing: 20,
                                  spacing: 20,
                                  children: <Widget>[
                                    InfoCard(
                                      title: "Heart Rate",
                                      iconPath: 'assets/icons/hr_icon.png',
                                      valueUnit: 'bpm',
                                      valueToShow: '${widget.doc_hr}',
                                      press: () {
                                        if (hitoryData.length > 0) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          HistoryPlot(
                                                            data: hitoryData,
                                                            expandedTitle: 'hr',
                                                          )));
                                        } else {
                                          return AlertDialog(
                                            title: Text('No history found'),
                                            content: Text(
                                                'Do you want to try again?'),
                                            actions: <Widget>[
                                              FlatButton(
                                                  onPressed: () {
                                                    print('ignored');
                                                  },
                                                  child: Text('No')),
                                              new FlatButton(
                                                  onPressed: () {
                                                    loadAsset();
                                                  },
                                                  child: new Text('Yes')),
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                    InfoCard(
                                      title: "Temperature",
                                      iconPath: 'assets/icons/temp_icon.png',
                                      valueUnit: '°C',
                                      valueToShow: '${widget.doc_temp}',
                                      press: () {
                                        if (hitoryData.length > 0) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          HistoryPlot(
                                                            data: hitoryData,
                                                            expandedTitle:
                                                                'temp',
                                                          )));
                                        } else {
                                          return AlertDialog(
                                            title: Text('No history found'),
                                            content: Text(
                                                'Do you want to try again?'),
                                            actions: <Widget>[
                                              FlatButton(
                                                  onPressed: () {
                                                    print('ignored');
                                                  },
                                                  child: Text('No')),
                                              new FlatButton(
                                                  onPressed: () {
                                                    loadAsset();
                                                  },
                                                  child: new Text('Yes')),
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 0, top: 20, right: 0, bottom: 20),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.deccolor3.withOpacity(.1),
                              borderRadius: BorderRadius.circular(25),
//                                            boxShadow: [
//                                              BoxShadow(
//                                                color: Colors.grey.withOpacity(0.05),
//                                                spreadRadius: 1,
//                                                blurRadius: 1,
//                                                offset: Offset(1, 2), // changes position of shadow
//                                              ),
//                                            ],
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
//                          height: 40,
                                  width: 60,
                                  child:
                                      Image.asset('assets/icons/spo2_icon.png'),
                                ),
                                SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Oxygen Saturation',
                                        style: TextStyle(
                                            color: AppColors.textColor,
                                            fontSize: 17),
                                      ),
//                              SizedBox(height: 4),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            '${widget.doc_spo2}',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35,
                                            ),
                                          ),
                                          SizedBox(width: 3),
                                          Text(
                                            '%',
                                            style: TextStyle(fontSize: 20),
//                                    textAlign: TextAlign.end,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 0, top: 20, right: 0, bottom: 20),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.deccolor3.withOpacity(.1),
                              borderRadius: BorderRadius.circular(25),
//                      boxShadow: [
//                        BoxShadow(
//                          color: Colors.grey.withOpacity(0.05),
//                          spreadRadius: 1,
//                          blurRadius: 1,
//                          offset: Offset(1, 2), // changes position of shadow
//                        ),
//                      ],
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
//                          height: 40,
                                  width: 60,
                                  child:
                                      Image.asset('assets/icons/rr_icon.png'),
                                ),
                                SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Respiration Rate',
                                        style: TextStyle(
                                            color: AppColors.textColor,
                                            fontSize: 17),
                                      ),
//                              SizedBox(height: 4),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            '${widget.doc_rr}',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35,
                                            ),
                                          ),
                                          SizedBox(width: 3),
                                          Text(
                                            'rpm',
                                            style: TextStyle(fontSize: 20),
//                                    textAlign: TextAlign.end,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
        );
      },
    );
  }
}
