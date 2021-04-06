import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class vs_item extends StatelessWidget {
  final String title;
  final String valueToShow;
  final String valueUnit;
  final String iconPath;
  final Function press;
  final double maxWidth;
  final bool isAbnormal;
  final double valueFontSize;
  final double maxHeight;
  final Icon icon;
  const vs_item({
    Key key,
    this.title,
    this.valueToShow,
    this.valueUnit,
    this.iconPath,
    this.press,
    this.maxWidth = 0,
    this.isAbnormal = false,
    this.valueFontSize = 36,
    this.maxHeight = 0,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: press,
          child: Container(
            width: maxWidth == 0 ? constraints.maxWidth / 3 - 20 : maxWidth,
            height: maxHeight == 0 ? constraints.maxWidth / 3 - 35 : maxHeight,
            // Here constraints.maxWidth provide us the available width for the widget
            decoration: BoxDecoration(
              color: !isAbnormal ? Colors.white : Color(0xFFFFD2D2),
              borderRadius: BorderRadius.circular(10),
              border: !isAbnormal
                  ? Border.all(width: 0, color: Color(0xFFFFFFFF))
                  : Border.all(width: 2.0, color: Color(0xFFE01A1A)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(1, 2), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      // wrapped within an expanded widget to allow for small density device
                      Container(
                        alignment: Alignment.topLeft,
                        height: 30,
//                            width: 30,
                        child:
                            iconPath.length > 0 ? Image.asset(iconPath) : icon,
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: AppColors.textColor,
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.clip,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, bottom: 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Text(
                          '$valueToShow',
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              fontSize: valueFontSize,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainColor),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                            right: 10,
                          ),
                          child: Text(
                            '$valueUnit',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainColor,
                                fontSize: 10),
                          ),
                        ),
                      ),
//                        Container(
//                          alignment: Alignment.bottomLeft,
//                          child: Text(
//                            'bpm',
//                            textAlign: TextAlign.right,
//                            style: TextStyle(),
//                          ),
//                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class vs_item_bp extends StatelessWidget {
  final String title;
  final String valueToShow;
  final String valueUnit;
  final String iconPath;
  final Function press;
  final double maxWidth;
  final bool isAbnormal;
  final String bp_MAP_value;
  final double valueFontSize;
  final double maxHeight;
  final Icon icon;

  const vs_item_bp({
    Key key,
    this.title,
    this.valueToShow,
    this.valueUnit,
    this.iconPath,
    this.press,
    this.maxWidth = 0,
    this.isAbnormal = false,
    this.bp_MAP_value = '100',
    this.valueFontSize = 36,
    this.maxHeight = 0,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: press,
          child: Container(
            width: maxWidth == 0 ? constraints.maxWidth / 3 - 20 : maxWidth,
            height: maxHeight == 0 ? constraints.maxWidth / 3 - 35 : maxHeight,
            // Here constraints.maxWidth provide us the available width for the widget
            decoration: BoxDecoration(
              color: !isAbnormal ? Colors.white : Color(0xFFFFD2D2),
              borderRadius: BorderRadius.circular(10),
              border: !isAbnormal
                  ? Border.all(width: 0, color: Color(0xFFFFFFFF))
                  : Border.all(width: 2.0, color: Color(0xFFE01A1A)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(1, 2), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Row(
                    children: <Widget>[
                      // wrapped within an expanded widget to allow for small density device
                      Container(
                        alignment: Alignment.topLeft,
                        height: 30,
//                            width: 30,
                        child:
                            iconPath.length > 0 ? Image.asset(iconPath) : icon,
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: AppColors.textColor,
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              // bottom: 10,
                              right: 10,
                              left: 5),
                          child: Text(
                            bp_MAP_value.length > 0
                                ? '($bp_MAP_value)'
                                : bp_MAP_value,
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainColor,
                                fontSize: 22),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, bottom: 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Text(
                          '$valueToShow',
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              fontSize: valueFontSize,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainColor),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                            right: 10,
                          ),
                          child: Text(
                            '$valueUnit',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainColor,
                                fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
