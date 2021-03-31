import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';
import 'package:vital_signs_ui_template/elements/User.dart';
import 'package:vital_signs_ui_template/pages/doctor_pages/docVSPage.dart';

class PatientInfo extends StatefulWidget {
  @override
  _PatientInfoState createState() => _PatientInfoState();
}

class _PatientInfoState extends State<PatientInfo> {
  final TextEditingController titleController = new TextEditingController();
  final GlobalKey<FormState> _keyDialogForm = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    titleController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 130, //no use of this fixed height
        turnOffBackButton: false,
        turnOffSettingsButton: true,
      ),
      body: SingleChildScrollView(
        child: PatientInfoForm_Element(),
      ),
    );
  }
}

class PatientInfoForm_Element extends StatefulWidget {
  final String patient_name;
  final String patient_gender;
  final DateTime patient_DOB;
  final List patient_medications;
  final List patient_diagnosis;
  final List patient_normal_range;
  final User clickedUser;

  const PatientInfoForm_Element(
      {Key key,
      this.patient_name = "Jack Brown",
      this.patient_gender = "Male",
      this.patient_DOB,
      this.patient_medications,
      this.patient_diagnosis,
      this.patient_normal_range,
      this.clickedUser})
      : super(key: key);

  @override
  PatientInfoForm_ElementState createState() {
    return PatientInfoForm_ElementState();
  }
}

// Create a corresponding State class. This class holds data related to the form.
class PatientInfoForm_ElementState extends State<PatientInfoForm_Element> {
  String _patient_name;
  String _patient_gender;
  DateTime _patient_DOB;
  List _patient_medications;
  List _patient_diagnosis;
  List _patient_normal_range;

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //final _formKey = GlobalKey<FormState>();
  final TextEditingController titleControllerMedication =
      new TextEditingController();
  final TextEditingController titleControllerDiagnosis =
      new TextEditingController();
  final GlobalKey<FormState> _keyDialogForm = new GlobalKey<FormState>();
  List<dynamic> medication = [];
  List<dynamic> diagnosis = [];
  bool medicationAdded = false;
  bool diagnosisAdded = false;

  bool isEditing = false;

  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    if (widget.clickedUser == null) {
      _patient_name = widget.patient_name;
      _patient_gender = widget.patient_gender;
      _patient_DOB = widget.patient_DOB ?? new DateTime.now();
      _patient_medications = widget.patient_medications;
      _patient_diagnosis = widget.patient_diagnosis;
      _patient_normal_range = widget.patient_normal_range;
      medication = widget.patient_medications;
      diagnosis = widget.patient_diagnosis;
    } else {
      _patient_name = widget.clickedUser.name;

      _patient_gender = widget.patient_gender;
      _patient_DOB = widget.patient_DOB ?? new DateTime.now();
      _patient_medications = widget.patient_medications;
      _patient_diagnosis = widget.patient_diagnosis;
      _patient_normal_range = widget.patient_normal_range;
      medication = widget.patient_medications;
      diagnosis = widget.patient_diagnosis;
    }

    super.initState();

    titleControllerMedication.text;
    titleControllerDiagnosis.text;

    medicationAdded = medication.length > 0 ? true : false;
    diagnosisAdded = diagnosis.length > 0 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: CustomAppBar(
        height: 130, //no use of this fixed height
        turnOffBackButton: false,
        turnOffSettingsButton: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _keyDialogForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text("Patient Information",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                        fontSize: 20,
                      )),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Row(
                    children: [
                      Flexible(
                        // margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: TextFormField(
                          enabled: false,
                          initialValue: _patient_name,
                          decoration: const InputDecoration(
                            //icon: const Icon(Icons.person),
                            labelText: 'Name',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: TextFormField(
                          enabled: false,
                          initialValue: _patient_gender,
                          decoration: const InputDecoration(
                            //icon: const Icon(Icons.person),
                            labelText: 'Gender',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Gender is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Text("Date of Birth",
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 16,
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        // decoration:
                        //     BoxDecoration(border: Border.all(color: Colors.black)),
                        child: Text(
                          "${_patient_DOB.toLocal()}".split(' ')[0],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: 20.0,
                      // ),
                      // RaisedButton(
                      //   onPressed: () => _selectDate(context), // Refer step 3
                      //   child: Text(
                      //     'Select date',
                      //     style: TextStyle(
                      //         color: Colors.black, fontWeight: FontWeight.bold),
                      //   ),
                      //   color: AppColors.deccolor2,
                      // ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: TextFormField(
                    enabled: isEditing,
                    decoration: const InputDecoration(
                      //icon: const Icon(Icons.person),
                      labelText: 'Medications',
                    ),
                    onSaved: (val) {
                      titleControllerMedication.text = val;
                      if (val.length > 1) {
                        setState(() {
                          print(val);
                          medication.add(val);
                          print(medication);
                          medicationAdded = true;
                          titleControllerMedication.clear();
                        });
                      }
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Medication is required';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                isEditing
                    ? Container(
                        margin: EdgeInsets.fromLTRB(315, 0, 0, 0),
                        child: SizedBox(
                          height: 30,
                          width: 60,
                          child: RaisedButton(
                            child: Text(
                              'Add',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              _keyDialogForm.currentState.save();
                            }, // Refer step 3
                            color: AppColors.deccolor2,
                          ),
                        ),
                      )
                    : Container(),
                medicationAdded
                    ? Padding(
                        padding:
                            const EdgeInsets.only(left: 15, bottom: 5, top: 5),
                        child: Text("Medications added: ",
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            )),
                      )
                    : Container(),
                SizedBox(
                  height: 2,
                ),
                medicationAdded
                    ? Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 5, 0),
                        child: Row(
                          children: medication.map((med) {
                            int index = medication
                                .indexOf(med); // use index if you want.
                            print(index);
                            return Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)),
                              child: Text(
                                med + "  ",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    : Container(),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: TextFormField(
                    enabled: isEditing,
                    decoration: const InputDecoration(
                      //icon: const Icon(Icons.person),
                      labelText: 'Diagnosis/Known for',
                    ),
                    onSaved: (val) {
                      if (val.length > 1) {
                        titleControllerDiagnosis.text = val;
                        setState(() {
                          print(val);
                          diagnosis.add(val);
                          //print(medication);
                          diagnosisAdded = true;
                          titleControllerDiagnosis.clear();
                        });
                      }
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Diagnosis is required';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                isEditing
                    ? Container(
                        margin: EdgeInsets.fromLTRB(315, 0, 0, 0),
                        child: SizedBox(
                          height: 30,
                          width: 60,
                          child: RaisedButton(
                            child: Text(
                              'Add',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              _keyDialogForm.currentState.save();
                            }, // Refer step 3
                            color: AppColors.deccolor2,
                          ),
                        ),
                      )
                    : Container(),
                diagnosisAdded
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(15, 5, 5, 10),
                        child: Text("Diagnosis added: ",
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            )),
                      )
                    : Container(),
                SizedBox(
                  height: 2,
                ),
                diagnosisAdded
                    ? Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 5, 10),
                        child: Row(
                          children: diagnosis.map((diag) {
                            int index = diagnosis
                                .indexOf(diag); // use index if you want.
                            print(index);
                            return Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)),
                              child: Text(
                                diag + "  ",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            );
                          }).toList(),
                        ))
                    : Container(),
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 5, 5, 10),
                  child: Text("Normal Ranges: ",
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Container(
                    child: NormalRangeItem(
                  isEditing: isEditing,
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isEditing
                        ? Container(
                            child: ElevatedButton(
                              child: const Text('Save'),
                              onPressed: () {
                                // if (_keyDialogForm.currentState.validate()) {
                                //   _keyDialogForm.currentState.save();
                                //   // If the form is valid, display a Snackbar.
                                //   Scaffold.of(context).showSnackBar(SnackBar(
                                //       content: Text('Data is in processing.')));
                                // }
                                setState(() {
                                  isEditing = false;
                                });
                              },
                            ),
                          )
                        : Container(),
                    !isEditing
                        ? Container(
                            child: ElevatedButton(
                              child: const Text('Edit'),
                              onPressed: () {
                                setState(() {
                                  isEditing = true;
                                });
                              },
                            ),
                          )
                        : Container(),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.greenButton)),
                        child: const Text('Open Vital Signs'),
                        onPressed: () {
                          if (widget.clickedUser != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => docVsVisualizerPage(
                                    clicked_user: widget.clickedUser),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NormalRangeItem extends StatelessWidget {
  final List range_hr;
  final List range_rr;
  final List range_spo2;
  final List range_temp;
  final bool isEditing;

  const NormalRangeItem(
      {Key key,
      this.range_hr = const [60, 100],
      this.range_rr = const [12, 22],
      this.range_spo2 = const [90, 100],
      this.range_temp = const [36.5, 37.5],
      this.isEditing = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 15),
      child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder.all(),
          children: [
            TableRow(children: [
              Text(
                'Heart rate',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 25,
                child: TextFormField(
                  initialValue: "${range_hr[0]}, ${range_hr[1]}",
                  enabled: isEditing,
                ),
              ),
            ]),
            TableRow(children: [
              Text(
                'Breathing rate',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 15,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 25,
                child: TextFormField(
                  enabled: isEditing,
                  initialValue: "${range_rr[0]}, ${range_rr[1]}",
                ),
              ),
            ]),
            TableRow(children: [
              Text(
                'O2 saturation',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 25,
                child: TextFormField(
                  enabled: isEditing,
                  initialValue: "${range_spo2[0]}, ${range_spo2[1]}",
                ),
              ),
            ]),
            TableRow(children: [
              Text(
                'Temperature',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 25,
                child: TextFormField(
                  enabled: isEditing,
                  initialValue: "${range_temp[0]}, ${range_temp[1]}",
                ),
              ),
            ]),
          ]),
    );
  }
}
