import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';

class StickyHeader_Test extends StatefulWidget {
  @override
  _StickyHeader_TestState createState() => _StickyHeader_TestState();
}

class _StickyHeader_TestState extends State<StickyHeader_Test> {
  DateTime selected_FromTime, selected_ToTime;
  bool showCustomRange = false;
  String selectedTime;
  String _selectedRadioButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        height: 120,
        turnOffBackButton: false,
        turnOffSettingsButton: true,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              showCustomRange
                  ? Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Row(
                        children: [
                          // Text('Filter by: ',
                          //     style: TextStyle(
                          //         fontSize: 15, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 40,
                            width: 50,
                            child: DateTimePicker(
                              type: DateTimePickerType.dateTime,
                              use24HourFormat: false,
                              icon: Icon(Icons.event),
                              //initialValue: "DateTime.now().toString()",
                              initialValue: " ",
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                              dateLabelText: 'From',
                              timeLabelText: "Hour",
                              onChanged: (val) {
                                DateTime selectedFromTime =
                                    DateTime.parse(val).toUtc();
                                setState(() {
                                  selected_FromTime = selectedFromTime;
                                });
                                print(
                                    'selected from---------> $selected_FromTime');
                              },
                              validator: (val) {
                                print(val);
                                return null;
                              },
                              onSaved: (val) => print(val),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            width: 50,
                            child: DateTimePicker(
                              enabled: selected_FromTime != null ? true : false,
                              type: DateTimePickerType.dateTime,
                              use24HourFormat: false,
                              icon: Icon(Icons.event),
                              //initialValue: DateTime.now().toString(),
                              initialValue: " ",
                              firstDate: selected_FromTime ?? DateTime.now(),
                              lastDate: DateTime(2100),
                              dateLabelText: 'To',
                              timeLabelText: "Hour",
                              onChanged: (val) {
                                DateTime selectedToTime =
                                    DateTime.parse(val).toUtc();
                                setState(() {
                                  selected_ToTime = selectedToTime;
                                });

                                print(
                                    'selected from---------> $selected_ToTime');
                              },
                              validator: (val) {
                                print(val);
                                return null;
                              },
                              onSaved: (val) => print(val),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: DropdownButton<String>(
                              value: selectedTime,
                              hint: Text(
                                'Min',
                                style: TextStyle(fontSize: 15),
                              ),
                              items: <String>['Min', 'Hour', 'Day', 'Month']
                                  .map((String value) {
                                //selectedFilterTime=value;
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              onChanged: (String newValue) {
                                setState(() {
                                  selectedTime = newValue;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 70.0,
                            height: 30.0,
                            //padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                color: Colors.blueAccent,
                                child: Text("Save",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                onPressed: () {}),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              Container(
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      if (showCustomRange == false) {
                        showCustomRange = true;
                      } else {
                        showCustomRange = false;
                      }
                    });
                  },
                  child: showCustomRange
                      ? Text(
                          'Custom',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )
                      : Text(
                          'Custom',
                          style: TextStyle(fontSize: 15),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
