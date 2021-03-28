import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';

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

    titleController.text = '';
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
        child: MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class. This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
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
    super.initState();

    titleControllerMedication.text = '';
    titleControllerDiagnosis.text = '';
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _keyDialogForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text("Enter Patient Information",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                  fontSize: 20,
                )),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: TextFormField(
              decoration: const InputDecoration(
                //icon: const Icon(Icons.person),
                hintText: 'Enter your name',
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
          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: TextFormField(
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
          Container(
            margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Date of Birth",
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 16,
                    )),
                Container(
                  //margin: const EdgeInsets.all(30.0),
                  padding: const EdgeInsets.all(5.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Text(
                    "${selectedDate.toLocal()}".split(' ')[0],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  onPressed: () => _selectDate(context), // Refer step 3
                  child: Text(
                    'Select date',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  color: AppColors.deccolor2,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: TextFormField(
              decoration: const InputDecoration(
                //icon: const Icon(Icons.person),
                labelText: 'Medication',
              ),
              onSaved: (val) {
                titleControllerMedication.text = val;
                setState(() {
                  print(val);
                  medication.add(val);
                  print(medication);
                  medicationAdded = true;
                });
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
          Container(
            margin: EdgeInsets.fromLTRB(315, 0, 0, 0),
            child: SizedBox(
              height: 30,
              width: 60,
              child: RaisedButton(
                child: Text(
                  'Add',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _keyDialogForm.currentState.save();
                }, // Refer step 3
                color: AppColors.deccolor2,
              ),
            ),
          ),
          medicationAdded
              ? Text("Medications added: ",
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ))
              : Container(),
          SizedBox(
            height: 2,
          ),
          medicationAdded
              ? Container(
                  child: Row(
                  children: medication.map((date) {
                    int index =
                        medication.indexOf(date); // use index if you want.
                    print(index);
                    return Container(
                      padding: const EdgeInsets.all(1.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: Text(
                        date + "  ",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    );
                  }).toList(),
                ))
              : Container(),
          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: TextFormField(
              decoration: const InputDecoration(
                //icon: const Icon(Icons.person),
                labelText: 'Diagnosis/Known for',
              ),
              onSaved: (val) {
                titleControllerDiagnosis.text = val;
                setState(() {
                  print(val);
                  diagnosis.add(val);
                  //print(medication);
                  diagnosisAdded = true;
                });
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
          Container(
            margin: EdgeInsets.fromLTRB(315, 0, 0, 0),
            child: SizedBox(
              height: 30,
              width: 60,
              child: RaisedButton(
                child: Text(
                  'Add',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _keyDialogForm.currentState.save();
                }, // Refer step 3
                color: AppColors.deccolor2,
              ),
            ),
          ),
          diagnosisAdded
              ? Text("Diagnosis added: ",
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ))
              : Container(),
          SizedBox(
            height: 2,
          ),
          diagnosisAdded
              ? Container(
                  child: Row(
                  children: diagnosis.map((diag) {
                    int index =
                        diagnosis.indexOf(diag); // use index if you want.
                    print(index);
                    return Container(
                      padding: const EdgeInsets.all(1.0),
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
          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: TextFormField(
              decoration: const InputDecoration(
                //icon: const Icon(Icons.person),
                labelText: 'Normal Range',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Range is required';
                }
                return null;
              },
            ),
          ),
          new Container(
              padding: const EdgeInsets.only(left: 150.0, top: 40.0),
              child: new RaisedButton(
                child: const Text('Submit'),
                onPressed: () {
                  if (_keyDialogForm.currentState.validate()) {
                    _keyDialogForm.currentState.save();
                    // If the form is valid, display a Snackbar.
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Data is in processing.')));
                  }
                },
              )),
        ],
      ),
    );
  }
}
