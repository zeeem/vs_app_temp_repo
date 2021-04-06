import 'package:flutter/material.dart';

import '../../../elements/CustomAppBar.dart';

class PatientInfoEdit extends StatefulWidget {
  @override
  _PatientInfoEditState createState() => _PatientInfoEditState();
}

class _PatientInfoEditState extends State<PatientInfoEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 120,
        turnOffBackButton: true,
        turnOffSettingsButton: true,
      ),
      body: Container(
        child: Column(
          children: [
            TextFormField(),
          ],
        ),
      ),
    );
  }
}
