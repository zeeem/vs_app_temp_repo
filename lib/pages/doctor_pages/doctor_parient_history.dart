import 'dart:async';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/configVS.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:vital_signs_ui_template/elements/User.dart';
import 'package:vital_signs_ui_template/elements/patient_tiles.dart';

import 'docVSPage.dart';

class DoctorPatientHistory extends StatefulWidget {
  @override
  _DoctorPatientHistoryState createState() => _DoctorPatientHistoryState();
}

class _DoctorPatientHistoryState extends State<DoctorPatientHistory> {
  Future<List<User>> _getUsers() async {
    return doctorData.patientList;
  }

  TextEditingController editingController = TextEditingController();
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<User>> key = new GlobalKey();
  static List<User> users = new List<User>();

  Widget row(User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 10),
          child: Text(
            user.name,
            style: TextStyle(fontSize: 20.0, color: AppColors.textColor),
          ),
        ),
        Spacer(),
      ],
    );
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
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Text(
                'Patients\' history',
                style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              //height: 55,
              //width: 380,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: searchTextField = AutoCompleteTextField<User>(
                key: key,
                clearOnSubmit: false,
                suggestions: doctorData.patientList,
                style: TextStyle(color: Colors.black, fontSize: 18.0),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 15),
                  hintText: "Search Name",
                  hintStyle: TextStyle(color: AppColors.textColor),
                ),
                itemFilter: (item, query) {
                  return item.name
                      .toLowerCase()
                      .startsWith(query.toLowerCase());
                },
                itemSorter: (a, b) {
                  return a.name.compareTo(b.name);
                },
                itemSubmitted: (item) {
                  setState(() {
                    searchTextField.textField.controller.text = item.name;
                  });
                },
                itemBuilder: (context, item) {
                  // ui for the autocompelete row
                  return row(item);
                },
              ),
            ),
            SizedBox(
              height: 10,
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
            SizedBox(
              height: 50,
            )
          ],
        ),
      );
    }
  }
}
