import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:vital_signs_ui_template/core/consts.dart';

import 'CustomAppBar.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    Key key,
    @required this.title,
    @required this.slivers,
    this.reverse = false,
  }) : super(key: key);

  final String title;
  final List<Widget> slivers;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return DefaultStickyHeaderController(
      child: Scaffold(
        appBar: CustomAppBar(
          height: 130, //no use of this fixed height
          turnOffSettingsButton: true,
        ),
        body: GestureDetector(
          onPanDown: (i) {
            print(i);
          },
          child: CustomScrollView(
            slivers: slivers,
            reverse: reverse,
          ),
        ),
        floatingActionButton: const _FloatingActionButton(),
      ),
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  const _FloatingActionButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.adjust),
      backgroundColor: AppColors.deccolor1,
      onPressed: () {
        final double offset =
            DefaultStickyHeaderController.of(context).stickyHeaderScrollOffset;
        PrimaryScrollController.of(context).animateTo(
          offset,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      },
    );
  }
}

//----------------------------VS plot header---------
class VSHeader extends StatelessWidget {
  const VSHeader({
    Key key,
    this.index,
    this.title,
    this.dateString,
    this.color = Colors.lightBlue,
    this.icon_location = "assets/icons/hr_icon.png",
  }) : super(key: key);

  final String title;
  final int index;
  final Color color;
  final String icon_location;
  final String dateString;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.white10.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(1, 3), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              Container(
                child: Image.asset(icon_location, width: 32, height: 32),
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                child: Text(title,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Text('starts $dateString'),
        ],
      ),
    );
  }
}
