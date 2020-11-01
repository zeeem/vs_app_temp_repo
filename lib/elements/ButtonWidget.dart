import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String buttonTitle;
  final Function onTapFunction;
  final int secondaryButtonStyle;
  const ButtonWidget(
      {Key key,
      @required this.buttonTitle,
      @required this.onTapFunction,
      this.secondaryButtonStyle})
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
              color: () {
                switch (secondaryButtonStyle) {
                  case 1:
                    return AppColors.secondaryButtonColor;
                    break;
                  case 2:
                    return AppColors.redButton;
                    break;
                  default:
                    return AppColors.buttonColor;
                    break;
                }
              }(),
//              secondaryButtonStyle > 2
//                  ? AppColors.buttonColor
//                  : AppColors.secondaryButtonColor,
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
