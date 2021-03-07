import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';
import 'package:vital_signs_ui_template/elements/info_card.dart';
//import 'package:flutter_svg/flutter_svg.dart';

String final_HR_to_show = '-';
String final_RR_to_show = '-';
String final_SPO2_to_show = '-';
String final_temp_to_show = '-';
String final_BP_to_show = '-';

class VSLoadWidgetStlss extends StatelessWidget {
  const VSLoadWidgetStlss({
    Key key,
  }) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vital Signs - Loading',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VSLoadingWidget(),
      builder: (BuildContext context, Widget child) {
        /// make sure that loading can be displayed in front of all other widgets
        return FlutterEasyLoading(child: child);
      },
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.deepOrangeAccent
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.orangeAccent
    ..textColor = Colors.orangeAccent
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..customAnimation = CustomAnimation();
}

class VSLoadingWidget extends StatefulWidget {
  const VSLoadingWidget({Key key}) : super(key: key);
  @override
  _VSLoadingWidgetState createState() => _VSLoadingWidgetState();
}

class _VSLoadingWidgetState extends State<VSLoadingWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    configLoading();
    EasyLoading.show(status: 'loading...');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          // resizeToAvoidBottomPadding: false,
          appBar: CustomAppBar(
            turnOffBackButton: true,
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
                        padding: EdgeInsets.fromLTRB(20, 20, 0, 0.0),
                        child: Text(
                          'Connecting to your vital signs...',
                          style: TextStyle(
                              fontSize: 20.0,
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
                                      valueToShow: '$final_HR_to_show',
                                      press: () {},
                                    ),
                                    InfoCard(
                                      title: "Temperature",
                                      iconPath: 'assets/icons/temp_icon.png',
                                      valueUnit: '°C',
                                      valueToShow: '$final_temp_to_show',
                                      press: () {},
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
                                            '$final_SPO2_to_show',
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
                                            '$final_RR_to_show',
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
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 0, top: 20, right: 0, bottom: 20),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.deccolor3.withOpacity(.1),
                              borderRadius: BorderRadius.circular(25),
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
                                            '${final_BP_to_show}', //widget.doc_bp
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
        );
      },
    );
  }
}

class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    double opacity = controller?.value ?? 0;
    return Opacity(
      opacity: opacity,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}
