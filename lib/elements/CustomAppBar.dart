import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/consts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  const CustomAppBar({Key key, this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var divHeight = MediaQuery.of(context).size.height;

    var height1 = divHeight / 2 * 0.325; //130
    var height2 = divHeight / 2 * 0.252; //100
    var height3 = divHeight / 2 * 0.18; //70
    return Container(
      height: divHeight / 2 * 0.35,
      child: Stack(
        children: <Widget>[
          Container(
            height: height1,
            decoration: BoxDecoration(
              color: AppColors.deccolor3,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          Container(
            height: height2,
            decoration: BoxDecoration(
              color: AppColors.deccolor2,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
          ),
          Container(
            height: height3,
            decoration: BoxDecoration(
              color: AppColors.deccolor1,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(250),
                bottomRight: Radius.circular(250),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
