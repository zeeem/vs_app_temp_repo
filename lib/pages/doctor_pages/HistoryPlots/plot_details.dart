import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';

class PlotDetails extends StatefulWidget {
  final int touchedIndex;
  final String touchedScale;

  const PlotDetails({Key key, this.touchedIndex, this.touchedScale})
      : super(key: key);

  @override
  _PlotDetailsState createState() => _PlotDetailsState();
}

class _PlotDetailsState extends State<PlotDetails> {
  int _touchedIndex;
  String _touchedScale;

  @override
  void initState() {
    _touchedIndex = widget.touchedIndex;
    _touchedScale = widget.touchedScale;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: CustomAppBar(
        height: 130, //no use of this fixed height
        turnOffBackButton: true,
        turnOffSettingsButton: true,
      ),
      body: Container(),
    );
  }
}
