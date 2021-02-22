import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String buttonTitle;
  final Function onTapFunction;
  final int secondaryButtonStyle;
  final double buttonHeight;
  final double bottomButtonPadding;
  final double buttonWidth;
  const ButtonWidget(
      {Key key,
      @required this.buttonTitle,
      @required this.onTapFunction,
      this.secondaryButtonStyle,
      this.buttonHeight = 60,
      this.bottomButtonPadding = 10,
      this.buttonWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double button_width;
    if (buttonWidth == null) {
      button_width = MediaQuery.of(context).size.width;
    } else {
      button_width = buttonWidth;
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10,
            10), //bottom = 20 (need to make it dynamic for alert page)
        child: GestureDetector(
          onTap: onTapFunction,
          child: Container(
            decoration: BoxDecoration(
              color: () {
                switch (secondaryButtonStyle) {
                  case 1:
                    return AppColors.secondaryButtonColor;
                    break;
                  case 2:
                    return AppColors.redButton;
                    break;
                  case 3:
                    return AppColors.yellowButton;
                  case 4:
                    return AppColors.greenButton;
                  default:
                    return AppColors.buttonColor;
                    break;
                }
              }(),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
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
            width: button_width,
            height: buttonHeight,
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
