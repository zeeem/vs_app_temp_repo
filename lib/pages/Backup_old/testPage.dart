// import 'package:flutter/material.dart';
// import 'package:loading/indicator/line_scale_indicator.dart';
// import 'package:loading/loading.dart';
// import 'package:scidart/numdart.dart';
// import 'package:vital_signs_ui_template/core/consts.dart';
// import 'package:vital_signs_ui_template/elements/ButtonWidget.dart';
// import 'package:vital_signs_ui_template/elements/info_card.dart';
// import 'package:vital_signs_ui_template/pages/AlertHomePage.dart';
//
// Array IR_raw_500 = Array.empty();
// Array RED_raw_500 = Array.empty();
//
// Array IR_raw_overlaped = Array.empty();
// Array RED_raw_overlaped = Array.empty();
//
// List warning_check_array =
//     []; //to look into multiple reading for specific period and then issue warning
// List temp_for_300sec = []; //temp data for 300 sec to check for warning
//
// int count = 0;
// bool isDeviceInUse = false; //checks if the device is being wore by the user
// bool isCompareOn =
//     false; //checks if it should record comparison data or raw data
//
// double _final_hr = 0;
// double _final_rr = 0;
// double _final_spo2 = 0;
// double _final_temp = 0;
//
// //for comparison
// double _comp_hr_300 = 0;
// double _comp_rr_300 = 0;
// double _comp_spo2_300 = 0;
//
// String final_HR_to_show = '84';
// String final_RR_to_show = '15';
// String final_SPO2_to_show = '99';
// String final_temp_to_show = '37.5';
//
// class DummyVSViz extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         resizeToAvoidBottomPadding: false,
//         body: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               Container(
//                 child: Stack(
//                   children: <Widget>[
//                     Container(
//                       height: 130,
//                       decoration: BoxDecoration(
//                         color: AppColors.deccolor3,
//                         borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(30),
//                           bottomRight: Radius.circular(30),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       height: 100,
//                       decoration: BoxDecoration(
//                         color: AppColors.deccolor2,
//                         borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(50),
//                           bottomRight: Radius.circular(50),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       height: 70,
//                       decoration: BoxDecoration(
//                         color: AppColors.deccolor1,
//                         borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(250),
//                           bottomRight: Radius.circular(250),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.fromLTRB(20, 100, 50, 0.0),
//                       child: Column(
//                         children: <Widget>[
//                           Text(
//                             'Welcome, Daniel',
//                             style: TextStyle(
//                                 fontSize: 25.0,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black.withOpacity(.7)),
//                             textAlign: TextAlign.left,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.fromLTRB(0, 50, 10, 0.0),
//                       alignment: Alignment.topRight,
//                       child: Loading(
//                           indicator: LineScaleIndicator(),
//                           size: 30.0,
//                           color: Colors.lightGreen),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
//                 child: Column(
//                   children: <Widget>[
//                     Center(
//                       child: Container(
//                         padding: EdgeInsets.only(
//                             left: 0, top: 20, right: 0, bottom: 20),
//                         width: double.infinity,
//                         decoration: BoxDecoration(
// //                      color: AppColors.mainColor.withOpacity(0.03),
//                           borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(50),
//                             bottomRight: Radius.circular(50),
//                           ),
//                         ),
//                         child: Center(
//                           child: Center(
//                             child: Wrap(
//                               runSpacing: 20,
//                               spacing: 20,
//                               children: <Widget>[
//                                 InfoCard(
//                                   title: "Heart Rate",
//                                   iconPath: 'assets/icons/hr_icon.png',
//                                   valueUnit: 'bpm',
//                                   valueToShow: '$final_HR_to_show',
//                                   press: () {},
//                                 ),
//                                 InfoCard(
//                                   title: "Temperature",
//                                   iconPath: 'assets/icons/temp_icon.png',
//                                   valueUnit: '°C',
//                                   valueToShow: '$final_temp_to_show',
//                                   press: () {},
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Center(
//                       child: Container(
//                         padding: EdgeInsets.only(
//                             left: 0, top: 20, right: 0, bottom: 20),
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: AppColors.deccolor3.withOpacity(.1),
//                           borderRadius: BorderRadius.circular(25),
// //                                            boxShadow: [
// //                                              BoxShadow(
// //                                                color: Colors.grey.withOpacity(0.05),
// //                                                spreadRadius: 1,
// //                                                blurRadius: 1,
// //                                                offset: Offset(1, 2), // changes position of shadow
// //                                              ),
// //                                            ],
//                         ),
//                         child: Row(
//                           children: <Widget>[
//                             Container(
//                               alignment: Alignment.center,
// //                          height: 40,
//                               width: 60,
//                               child: Image.asset('assets/icons/spo2_icon.png'),
//                             ),
//                             SizedBox(width: 10),
//                             Padding(
//                               padding: const EdgeInsets.all(0.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   Text(
//                                     'Oxygen Saturation',
//                                     style: TextStyle(
//                                         color: AppColors.textColor,
//                                         fontSize: 17),
//                                   ),
// //                              SizedBox(height: 4),
//                                   Row(
//                                     children: <Widget>[
//                                       Text(
//                                         '$final_SPO2_to_show',
//                                         textAlign: TextAlign.start,
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 35,
//                                         ),
//                                       ),
//                                       SizedBox(width: 3),
//                                       Text(
//                                         '%',
//                                         style: TextStyle(fontSize: 20),
// //                                    textAlign: TextAlign.end,
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Center(
//                       child: Container(
//                         padding: EdgeInsets.only(
//                             left: 0, top: 20, right: 0, bottom: 20),
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: AppColors.deccolor3.withOpacity(.1),
//                           borderRadius: BorderRadius.circular(25),
// //                      boxShadow: [
// //                        BoxShadow(
// //                          color: Colors.grey.withOpacity(0.05),
// //                          spreadRadius: 1,
// //                          blurRadius: 1,
// //                          offset: Offset(1, 2), // changes position of shadow
// //                        ),
// //                      ],
//                         ),
//                         child: Row(
//                           children: <Widget>[
//                             Container(
//                               alignment: Alignment.center,
// //                          height: 40,
//                               width: 60,
//                               child: Image.asset('assets/icons/rr_icon.png'),
//                             ),
//                             SizedBox(width: 10),
//                             Padding(
//                               padding: const EdgeInsets.all(0.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   Text(
//                                     'Respiration Rate',
//                                     style: TextStyle(
//                                         color: AppColors.textColor,
//                                         fontSize: 17),
//                                   ),
// //                              SizedBox(height: 4),
//                                   Row(
//                                     children: <Widget>[
//                                       Text(
//                                         '$final_RR_to_show',
//                                         textAlign: TextAlign.start,
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 35,
//                                         ),
//                                       ),
//                                       SizedBox(width: 3),
//                                       Text(
//                                         'rpm',
//                                         style: TextStyle(fontSize: 20),
// //                                    textAlign: TextAlign.end,
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         bottomNavigationBar: ButtonWidget(
//             buttonTitle: 'I NEED HELP',
//             secondaryButtonStyle: 2,
//             onTapFunction: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (_) => AlertHomePage(
//                     alert_text:
//                         'Here are your contact numbers. Don\'t wait and click on a button to get assistance!',
//                   ),
//                 ),
//               );
//             }));
//   }
// }
