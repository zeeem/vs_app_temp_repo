import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/configVS.dart';
import 'package:vital_signs_ui_template/elements/User.dart';
import 'package:vital_signs_ui_template/elements/patient_tiles.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'docVSPage.dart';

class DoctorPatientHistory extends StatefulWidget {
  @override
  _DoctorPatientHistoryState createState() => _DoctorPatientHistoryState();
}

class _DoctorPatientHistoryState extends State<DoctorPatientHistory> {
  Future<List<User>> _getUsers() async {
    return doctorData.patientList;
  }

  var data = doctorData.patientList;
  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Container(
        child: Center(
          child: Text('Loading...'),
        ),
      );
    } else {
      return Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                'Patients\' history',
                style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              // padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              height: 550, //height of TabBarView
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  //checking if priority is 2 (0=low, 1=medium, 2=high)
                  return PatientTiles(
                    title: data[index].name,
                    networkProfilePicture: data[index].picture,
                    // priorityLevel: 2,
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => docVsVisualizerPage(
                                  clicked_user: data[index])));
                    },
                  );
                },
              ),
            ),
            // SizedBox(
            //   height: 50,
            // )
          ],
        ),
      );
    }
  }
}
