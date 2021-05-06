import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_app/core/consts.dart';

class PatientTiles extends StatelessWidget {
  final String title;
  final String networkProfilePicture;
  final Function onPress;
  final int priorityLevel;
  const PatientTiles({
    Key key,
    this.title,
    this.networkProfilePicture = '',
    this.onPress,
    this.priorityLevel = -1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: onPress,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: Container(
              width: constraints.maxWidth,
              // Here constraints.maxWidth provide us the available width for the widget
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(1, 1), // changes position of shadow
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Row(
                        children: <Widget>[
                          // wrapped within an expanded widget to allow for small density device
                          Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                alignment: Alignment.topLeft,
                                height: 45,
//                            width: 30,
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: AppColors.textColor,
                                  child: CircleAvatar(
                                    radius: 21,
                                    backgroundImage: networkProfilePicture
                                                .length <
                                            1
                                        ? AssetImage(
                                            'assets/images/profile1.png')
                                        : NetworkImage(networkProfilePicture),
                                  ),
                                ),
                              ),
                              (() {
                                switch (priorityLevel) {
                                  case 0:
                                    return Container(
                                      child: Image.asset(
                                        'assets/icons/alert_normal.png',
                                        scale: 1.4,
                                      ),
                                    );
                                  case 1:
                                    return Container(
                                      child: Image.asset(
                                        'assets/icons/alert_borderline.png',
                                        scale: 1.4,
                                      ),
                                    );
                                  case 2:
                                    return Container(
                                      child: Image.asset(
                                        'assets/icons/alert 1.png',
                                        scale: 1.2,
                                      ),
                                    );

                                  default:
                                    return Container();
                                }
                              }()),
                              // priorityLevel == 2
                              //     ? Container(
                              //         child: Image.asset(
                              //             'assets/icons/alert 1.png'),
                              //       )
                              //     : Container(
                              //         child: Image.asset(
                              //             'assets/icons/alert_borderline.png'),
                              //       ),
                            ],
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.textColor.withOpacity(.8),
                                ),
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.clip,
                              ),
                              Text(
                                'Click to know more',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13,
                                  color: AppColors.textColor.withOpacity(.7),
                                ),
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.clip,
                              ),
                            ],
                          ),
                          Spacer(),
                          Icon(
                            Icons.play_arrow_sharp,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
