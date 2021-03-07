import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/elements/ButtonWidget.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';

import 'configuration_page11.dart';

class ConfigurationPage10 extends StatefulWidget {
  @override
  _ConfigurationPage10 createState() => _ConfigurationPage10();
}

class _ConfigurationPage10 extends State<ConfigurationPage10> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
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
                    'One last step and we are done. In case you are unable to talk on the phone, can you please give the app access to your GPS in case of emergency. Just click accept on the next message.',
                    style:
                        TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
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
                builder: (_) => ConfigurationPage11(),
              ),
            );
          }),
    );
  }
}
