import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Shared {
  static MakeToast(String toast_msg) {
    Fluttertoast.showToast(
        msg: "$toast_msg",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0);
  }
}
