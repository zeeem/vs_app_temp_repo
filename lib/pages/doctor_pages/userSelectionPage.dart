// import 'package:vital_signs_ui_template/core/configVS.dart';
// import 'package:vital_signs_ui_template/elements/ButtonWidget.dart';
// import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';
//
// import 'docPatientListPage.dart';
// import 'package:flutter/material.dart';
// import 'package:vital_signs_ui_template/core/consts.dart';
//
// import 'doctorConditionnPage.dart';
//
// class UserSelectionPage extends StatefulWidget {
//   @override
//   _UserSelectionPage createState() => _UserSelectionPage();
// }
//
// class _UserSelectionPage extends State<UserSelectionPage> {
//   final userNameController = TextEditingController();
//   final userPhoneController = TextEditingController();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomPadding: false,
//       resizeToAvoidBottomInset: true,
//       appBar: CustomAppBar(
//         height: 130, //no use of this fixed height
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Container(
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     padding: EdgeInsets.fromLTRB(50, 50, 50, 0.0),
//                     child: Text(
//                       'Who are you?',
//                       style: TextStyle(
//                           fontSize: 21.0, fontWeight: FontWeight.bold),
//                       textAlign: TextAlign.center,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Container(
//                 padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Expanded(
//                       // padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
//                       child: IconButton(
//                         iconSize: 200,
//                         icon: Image.asset(
//                           "assets/images/physician.png",
//                         ),
//                         onPressed: () {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (_) => DoctorConditionPage(),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     Expanded(
//                       // padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
//                       child: IconButton(
//                         iconSize: 200,
//                         icon: Image.asset(
//                           "assets/images/patient.png",
//                         ),
//                         onPressed: () {},
//                       ),
//                     ),
//                   ],
//                 )),
//           ],
//         ),
//       ),
//       // bottomNavigationBar: ButtonWidget(
//       //   buttonTitle: 'Next',
//       //   onTapFunction: () {
//       //     //saving PROFILE data in the static vars
//       //     // profileData.USER_FULL_NAME = userNameController.text;
//       //     // profileData.USER_PHONE = userPhoneController.text;
//       //     Navigator.of(context).push(
//       //       MaterialPageRoute(
//       //         // builder: (_) => (),
//       //       ),
//       //     );
//       //   },
//       // ),
//     );
//   }
// }
