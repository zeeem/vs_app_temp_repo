import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'ButtonWidget.dart';
import 'CustomAppBar.dart';

class TryAgainPage extends StatelessWidget {
  final String displayText;
  final Color displayTextColor;
  final String buttonText;
  final String displayText2;
  final bool isButtonVisible;
  final Function buttonClick;
  final bool isLoadingVisible;
  final bool userAsElement;

  const TryAgainPage(
      {Key key,
      this.displayText = 'Opps! Something is wrong! Please try again.',
      this.buttonText = 'Try Again',
      this.displayText2 = '',
      this.buttonClick,
      this.displayTextColor,
      this.isButtonVisible = false,
      this.isLoadingVisible = false,
      this.userAsElement = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !userAsElement
        ? Scaffold(
            resizeToAvoidBottomPadding: false,
            resizeToAvoidBottomInset: true,
            appBar: CustomAppBar(
              turnOffBackButton: true,
              turnOffSettingsButton: true,
              height: 130, //no use of this fixed height
            ),
            body: TryAgain_element(
              displayText: displayText,
              displayText2: displayText2,
              displayTextColor: displayTextColor,
              isLoadingVisible: isLoadingVisible,
              isButtonVisible: isButtonVisible,
              buttonText: buttonText,
              buttonClick: buttonClick,
            ),
            bottomNavigationBar: isButtonVisible
                ? ButtonWidget(
                    buttonTitle: buttonText,
                    secondaryButtonStyle: 0,
                    onTapFunction: buttonClick)
                : FlatButton(onPressed: () {}, child: Text('')),
          )
        : TryAgain_element(
            displayText: displayText,
            displayText2: displayText2,
            displayTextColor: displayTextColor,
            isLoadingVisible: isLoadingVisible,
            isButtonVisible: isButtonVisible,
            buttonText: buttonText,
            buttonClick: buttonClick,
          );
  }
}

class TryAgain_element extends StatelessWidget {
  final String displayText;
  final Color displayTextColor;
  final String buttonText;
  final String displayText2;
  final bool isButtonVisible;
  final Function buttonClick;
  final bool isLoadingVisible;

  const TryAgain_element(
      {Key key,
      this.displayText = 'Opps! Something is wrong! Please try again.',
      this.buttonText = 'Try Again',
      this.displayText2 = '',
      this.buttonClick,
      this.displayTextColor,
      this.isButtonVisible = false,
      this.isLoadingVisible = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(50, 25, 50, 0.0),
                  child: Align(
                    child: Image.asset(
                      "assets/images/vs_avatar_01.png",
                      scale: 0.90,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(50, 50, 50, 0.0),
                  child: Text(
                    displayText,
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: displayTextColor != null
                            ? displayTextColor
                            : AppColors.textColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 25),
                  child: Text(
                    displayText2,
                    style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                isLoadingVisible
                    ? Container(
                        padding: EdgeInsets.fromLTRB(20, 25, 20, 10),
                        child: Loading(
                          indicator: BallSpinFadeLoaderIndicator(),
                          size: 100.0,
                          color: AppColors.deccolor2,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
