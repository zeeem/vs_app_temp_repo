import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:vital_signs_ui_template/pages/registration/profile_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final bool turnOffBackButton;
  final bool turnOffSettingsButton;

  const CustomAppBar(
      {Key key,
      this.height,
      this.turnOffBackButton = false,
      this.turnOffSettingsButton = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var divHeight = MediaQuery.of(context).size.height;

    var height1 = divHeight / 2 * 0.325; //130
    var height2 = divHeight / 2 * 0.252; //100
    var height3 = divHeight / 2 * 0.18; //70
    return Container(
//      height: divHeight / 2 * 0.35,
      height: height1,
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
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(1, 2), // changes position of shadow
                ),
              ],
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
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                !turnOffBackButton
                    ? Container(
                        //back button
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.textColor,
                          ),
                          onPressed: () {
                            Navigator.maybePop(context);
                          },
                        ),
                      )
                    : SizedBox(
                        width: 0,
                      ),
                !turnOffSettingsButton
                    ? Container(
//                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0.0),
//                  alignment: Alignment.topRight,
                        child: IconButton(
                          iconSize: 35,
                          icon: Icon(
                            Icons.settings,
                            color: AppColors.textColor,
//                      size: 40,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage()),
                            );
                          },
                        ),
                      )
                    : SizedBox(
                        width: 0,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
