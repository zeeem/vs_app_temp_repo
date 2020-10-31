import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String buttonTitle;
  final Function onTapFunction;

  const ButtonWidget({Key key, this.buttonTitle, this.onTapFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: GestureDetector(
          onTap: onTapFunction,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.buttonColor,
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(1, 1),
                  spreadRadius: 1,
                  blurRadius: 3,
                )
              ],
            ),
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: Center(
              child: Text(
                "$buttonTitle",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
