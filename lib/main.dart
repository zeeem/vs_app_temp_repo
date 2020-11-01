import 'package:flutter/material.dart';
import 'pages/registration/configuration_page1.dart';
import 'pages/registration/condition_page.dart';
import 'pages/connectDevice.dart';

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
      home: ConditionPage(), //ConditionPage()
    );
  }
}
