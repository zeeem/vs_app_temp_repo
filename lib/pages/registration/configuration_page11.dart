import 'package:vital_signs_ui_template/elements/ButtonWidget.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';

import 'configuration_page8.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:vital_signs_ui_template/pages/connectDevice.dart';

class ConfigurationPage11 extends StatefulWidget {
  @override
  _ConfigurationPage11 createState() => _ConfigurationPage11();
}

class _ConfigurationPage11 extends State<ConfigurationPage11> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

//  getDirLocation() async {
//
//    File file = await File('$path/counter.txt');
//    file.writeAsString('this is test');
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: CustomAppBar(
        height: 130, //no use of this fixed height
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(50, 0, 50, 0.0),
                  child: Align(
                    child: Image.asset(
                      "assets/images/vs_avatar_01.png",
                      scale: 0.90,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(50, 10, 50, 0.0),
                  child: Text(
                    'Thank you for your time. Everything is now ready to help monitor your health.',
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
      bottomNavigationBar: ButtonWidget(
          buttonTitle: 'Next',
          onTapFunction: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ConnectDevice(),
              ),
            );
          }),
    );
  }
}
