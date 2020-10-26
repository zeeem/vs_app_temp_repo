import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/pages/formsfill_page.dart';
import 'package:vital_signs_ui_template/pages/intro_page.dart';
import 'package:vital_signs_ui_template/pages/condition_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: "OpenSans",
      ),
      home: FormsfillPage(),
    );
  }
}
