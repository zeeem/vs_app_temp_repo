import 'dart:math';

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
import 'HistoryPlots/HistoryPlot.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class docVsVisualizerPage extends StatefulWidget {
  final User clicked_user;
  final String doc_hr;
  final String doc_rr;
  final String doc_spo2;
  final String doc_temp;
  final String doc_bp;


  const docVsVisualizerPage(
      {Key key,
      this.clicked_user,
      this.doc_hr = '78',
      this.doc_rr = '16',
      this.doc_spo2 = '99',
      this.doc_temp = '37',
      this.doc_bp = '125/85'})
      : super(key: key);

  @override
  _docVsVisualizerPageState createState() => _docVsVisualizerPageState();
}

class _docVsVisualizerPageState extends State<docVsVisualizerPage> {
  List<dynamic> historyData = [];

  String _doc_hr;
  String _doc_rr;
  String _doc_spo2;
  String _doc_temp;
  String _doc_bp;

  loadAsset() async {
    final myData = await rootBundle.loadString("assets/csv/dummy2.csv");

    //print(myData);
    List<dynamic> csvTable = CsvToListConverter().convert(myData);
    print(csvTable[0].last);

    historyData = csvTable;

    // print(historyData);
  }

  @override
  void initState() {
    loadAsset();

    _doc_hr = widget.doc_hr;
    _doc_rr = widget.doc_rr;
    _doc_spo2 = widget.doc_spo2;
    _doc_temp = widget.doc_temp;
    _doc_bp = widget.doc_bp;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Random random = new Random();
    int sbp = 124 + random.nextInt(7);
    int dbp = 85 + random.nextInt(4);
    String rand_bp_to_show = '$sbp/$dbp';

    _doc_hr = (80 + random.nextInt(40)).toString();
    _doc_hr = (120).toString();

    _doc_rr = (16 + random.nextInt(5)).toString();
    _doc_spo2 = (99 - random.nextInt(4)).toString();
    _doc_temp = (36.5 + random.nextInt(2)).toString();
    _doc_temp = (37 + random.nextInt(1)).toString();
    _doc_bp = rand_bp_to_show;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: CustomAppBar(
            turnOffBackButton: false,
            turnOffSettingsButton: false,
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
                    padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
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
                                      valueToShow: '${_doc_hr}',
                                      press: () {
                                        if (historyData.length > 0) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          HistoryPlot(
                                                            data: historyData,
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
                                      valueToShow: '${_doc_temp}',
                                      press: () {
                                        if (historyData.length > 0) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          HistoryPlot(
                                                            data: historyData,
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
                        SizedBox(height: 0),
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 0, top: 10, right: 0, bottom: 20),
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
                                GestureDetector(
                                  onTap: (){
                                    if (historyData.length > 0) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder:
                                                  (BuildContext context) =>
                                                  HistoryPlot(
                                                    data: historyData,
                                                    expandedTitle:
                                                    'spo2',
                                                  )));
                                    }
                                  },
                                  child: Padding(
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
                                              '${_doc_spo2}',
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
                                            '${_doc_rr}',
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
                                      Image.asset('assets/icons/bp_icon.png'),
                                ),
                                SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Blood Pressure',
                                        style: TextStyle(
                                            color: AppColors.textColor,
                                            fontSize: 17),
                                      ),
//                              SizedBox(height: 4),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            '${_doc_bp}', //widget.doc_bp
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35,
                                            ),
                                          ),
                                          SizedBox(width: 3),
                                          Text(
                                            'mmHg',
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
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assessment),
                title: Text('History'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.warning),
                title: Text('HELP'),
              ),
            ],
            currentIndex: 0,
            selectedItemColor: AppColors.deccolor1,
            // onTap: _onItemTapped,
          ),
        );
      },
    );
  }
}
