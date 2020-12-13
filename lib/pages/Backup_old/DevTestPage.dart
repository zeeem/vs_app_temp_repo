import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/consts.dart';

class devTestPage extends StatefulWidget {
  @override
  _devTestPageState createState() => _devTestPageState();
}

class _devTestPageState extends State<devTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Center(
            child: Column(
              children: [
                Text('Background process test --- '),
                RaisedButton(
                  onPressed: () async {
                    print(await compute(testFunction, ''));
                  },
                  child: Text('Timer check'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

testFunction(String str) async {
  Timer timer = Timer(Duration(seconds: 10), () {
    print('timer executed');
  });

  await Future.delayed(Duration(seconds: 15));

  print('delay excuted');

  await Future.delayed(Duration(seconds: 15));

  print('timer executed 2');

  // return 'function ended';
}
