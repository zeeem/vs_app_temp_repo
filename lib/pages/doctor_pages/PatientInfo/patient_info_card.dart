import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vital_signs_ui_template/elements/User.dart';
import 'package:vital_signs_ui_template/pages/doctor_pages/AutoComplete/Disease.dart';
import 'package:vital_signs_ui_template/pages/doctor_pages/AutoComplete/Drug.dart';
import 'package:vital_signs_ui_template/elements/range_card.dart';

import '../../../core/configVS.dart';
import '../../../core/consts.dart';
import '../../Dashboard/vs_item.dart';

Map<String, List<dynamic>> normalRangeMap = {
  "HR": [60, 100],
  "RR": [12, 25],
  "SPO2": [90, 100],
  "TEMP": [36, 38],
  "BP": [60, 90, 90, 130] //diastolic min-max, systolic min-max
};

bool isTextInSearchField = false; //Fixme: need to make it work

class Patient_info_card extends StatefulWidget {
  final double full_width;
  final User clickedUser; // it has to be <UserProfile>
  // these two will come from <UserProfile>
  final String patient_gender;
  final DateTime patient_DOB;

  const Patient_info_card(
      {Key key,
      this.full_width,
      this.clickedUser,
      this.patient_gender,
      this.patient_DOB})
      : super(key: key);

  @override
  _Patient_info_cardState createState() => _Patient_info_cardState();
}

class _Patient_info_cardState extends State<Patient_info_card> {
  String patientName = '';
  bool loaded = false;
  String medications = '';
  String diagnosis = '';

  DateTime patient_DOB;
  String patient_gender;

  String iconPath = "";

  Map<String, List<dynamic>> _normalRangeMap;

  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<Drug>> key = new GlobalKey();
  bool loading = true;
  String selectedMed = "";

  @override
  void initState() {
    patientName = widget.clickedUser.name ?? "";
    patient_DOB = widget.patient_DOB;
    patient_gender = widget.patient_gender;

    // if (PATIENT_INFO.medicationList == null) {
    //   PATIENT_INFO.medicationList = ['Tylenol', 'Aptiom', 'TEFLARO'];
    // }
    // if (PATIENT_INFO.diagnosisList == null) {
    //   PATIENT_INFO.diagnosisList = ['OCD', 'High BP', 'Heart Disease'];
    // }

    if (patient_gender.toLowerCase() == "male") {
      iconPath = "assets/icons/Male-icon.png";
    } else {
      iconPath = "assets/icons/Female-icon.png";
    }

    updateMedicationsAndDiagnosis();

    loaded = true;
    // TODO: implement initState
    super.initState();
  }

  updateMedicationsAndDiagnosis() {
    setState(() {
      medications = PATIENT_INFO.medicationList
          .toString()
          .replaceAll("[", "")
          .replaceAll(']', "");

      diagnosis = PATIENT_INFO.diagnosisList
          .toString()
          .replaceAll("[", "")
          .replaceAll(']', "");

      PATIENT_INFO.NORMAL_RANGES = normalRangeMap;
    });

    medications = medications.length > 27
        ? medications.replaceRange(27, medications.length, "...")
        : medications;
    diagnosis = diagnosis.length > 27
        ? diagnosis.replaceRange(27, diagnosis.length, "...")
        : diagnosis;

    _normalRangeMap = normalRangeMap;
  }

  updateNormalRanges(String vsName) {
    if (double.tryParse(rangeControllerMax.text) >
        double.tryParse(rangeControllerMin.text)) {
      normalRangeMap[vsName][0] = rangeControllerMin.text;
      normalRangeMap[vsName][1] = rangeControllerMax.text;
    } else {
      makeToast("Max value must be greater than the Min value");
    }
  }

  Future<void> showPopUpDialog(BuildContext context, var dialogWidget,
      [String buttonText, String rangeVSName]) async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: dialogWidget,
            ),
            actions: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: ElevatedButton(
                    onPressed: () {
                      if (rangeVSName == null && isTextInSearchField == true) {
                        makeToast("Hit (+) to save the changes.");
                        return;
                      }
                      updateMedicationsAndDiagnosis();
                      isTextInSearchField = false;
                      if (rangeVSName != null) {
                        updateNormalRanges(rangeVSName);
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      buttonText ?? "Go Back",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(AppColors.deccolor1),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                        //color: Colors.white,
                                        ))))),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (loaded) {
      setState(() {
        updateMedicationsAndDiagnosis();
      });
    }
    var w = widget.full_width / 2;
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("$patientName",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                      fontSize: 20,
                    )),
                TextButton(
                  onPressed: () {
                    updateMedicationsAndDiagnosis();
                  },
                  child: Icon(
                    Icons.info_outline,
                    color: AppColors.deccolor1,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            runSpacing: 10,
            spacing: 15,
            children: <Widget>[
              vs_item(
                maxWidth: w,
                valueFontSize: 25,
                title: 'Gender',
                valueToShow: '$patient_gender',
                valueUnit: '',
                iconPath: iconPath,
                // icon: Icon(Icons.account_box_sharp),
                maxHeight: 80,
              ),
              vs_item(
                maxWidth: w,
                valueFontSize: 25,
                title: 'DOB',
                valueToShow: "${patient_DOB.toLocal()}".split(' ')[0],
                valueUnit: '',
                iconPath: '',
                icon: Icon(
                  Icons.date_range_rounded,
                  size: 28,
                  color: AppColors.deccolor2,
                ),
                maxHeight: 80,
              ),
              vs_item_bp(
                title: 'Medications',
                valueFontSize: 22,
                valueToShow: medications,
                maxHeight: 90,
                valueUnit: '',
                iconPath: 'assets/icons/rx-icon.png',
                press: () async {
                  await showPopUpDialog(context, AutoCompleteDrugs());
                  // navigateTo(context, AutoCompleteDrugs());
                  // Function f;
                  // f = await Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => AutoCompleteDrugs()),
                  // );
                  // f();
                },
                maxWidth: widget.full_width + 12,
                bp_MAP_value: "",
              ),
              vs_item_bp(
                title: 'Diagnosis',
                valueFontSize: 22,
                valueToShow: diagnosis,
                maxHeight: 90,
                valueUnit: '',
                iconPath: 'assets/icons/diagnosis-icon.jpg',
                maxWidth: widget.full_width + 12,
                bp_MAP_value: "",
                press: () async {
                  await showPopUpDialog(context, AutoCompleteDiagnosis());
                  // navigateTo(context, AutoCompleteDrugs());
                  // Function f;
                  // f = await Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => AutoCompleteDrugs()),
                  // );
                  // f();
                },
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
            child: Text(
              "Normal Range",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColors.textColor,
              ),
              maxLines: 1,
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
            ),
          ),
          normalRangeTile(
            clickHR: () async {
              await showPopUpDialog(
                  context,
                  changeNormalRange(
                    titleText: "Heart Rate",
                    vs_key: "HR",
                  ),
                  "Save",
                  "HR");
            },
            clickRR: () async {
              await showPopUpDialog(
                  context,
                  changeNormalRange(
                    titleText: "Breathing Rate",
                    vs_key: "RR",
                  ),
                  "Save",
                  "RR");
            },
            clickSpo2: () async {
              await showPopUpDialog(
                  context,
                  changeNormalRange(
                    titleText: "SpO2",
                    vs_key: "SPO2",
                  ),
                  "Save",
                  "SPO2");
            },
            clickTemp: () async {
              await showPopUpDialog(
                  context,
                  changeNormalRange(
                    titleText: "Temperature",
                    vs_key: "TEMP",
                  ),
                  "Save",
                  "TEMP");
            },
            clickBP: () async {
              await showPopUpDialog(
                  context,
                  changeNormalRange(
                    titleText: "Blood Pressure",
                    vs_key: "BP",
                  ),
                  "Save",
                  "BP");
            },
          ),
          // Container(
          //   alignment: Alignment.bottomRight,
          //   padding: EdgeInsets.fromLTRB(20, 10, 15, 0),
          //   child: ElevatedButton(
          //     style: ButtonStyle(
          //         backgroundColor:
          //             MaterialStateProperty.all<Color>(AppColors.greenButton)),
          //     child: const Text('Open Vital Signs'),
          //     onPressed: () {
          //       if (widget.clickedUser != null) {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) =>
          //                 docVsVisualizerPage(clicked_user: widget.clickedUser),
          //           ),
          //         );
          //       }
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

class normalRangeTile extends StatelessWidget {
  final Function clickHR, clickRR, clickTemp, clickSpo2, clickBP;
  const normalRangeTile(
      {Key key,
      this.clickHR,
      this.clickRR,
      this.clickTemp,
      this.clickSpo2,
      this.clickBP})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double fontSize = 24;
    return Container(
      child: Center(
        child: Wrap(
          runSpacing: 10,
          spacing: 15,
          children: <Widget>[
            range_card(
              title: 'HR',
              minVal: '${normalRangeMap["HR"][0]}',
              maxVal: '${normalRangeMap["HR"][1]}',
              // valueToShow:
              //     '${normalRangeMap["HR"][0]}/${normalRangeMap["HR"][1]}',
              valueUnit: '',
              iconPath: 'assets/icons/hr_icon.png',
              press: clickHR,
              valueFontSize: fontSize,
            ),
            range_card(
              title: 'TEMP',
              minVal: '${normalRangeMap["TEMP"][0]}',
              maxVal: '${normalRangeMap["TEMP"][1]}',
              // valueToShow:
              //     '${normalRangeMap["TEMP"][0]}/${normalRangeMap["TEMP"][1]}',
              valueUnit: '',
              iconPath: 'assets/icons/temp_icon2.png',
              press: clickTemp,
              valueFontSize: fontSize,
            ),
            range_card(
              title: 'SPO2',
              minVal: '${normalRangeMap["SPO2"][0]}',
              maxVal: '${normalRangeMap["SPO2"][1]}',
              // valueToShow:
              //     '${normalRangeMap["SPO2"][0]}/${normalRangeMap["SPO2"][1]}',
              valueUnit: '',
              iconPath: 'assets/icons/spo2_icon.png',
              press: clickSpo2,
              valueFontSize: fontSize,
            ),
            range_card(
              title: 'RR',
              minVal: '${normalRangeMap["RR"][0]}',
              maxVal: '${normalRangeMap["RR"][1]}',
              // valueToShow:
              //     '${normalRangeMap["RR"][0]}/${normalRangeMap["RR"][1]}',
              valueUnit: '',
              iconPath: 'assets/icons/rr_icon.png',
              press: clickRR,
              valueFontSize: fontSize,
            ),
            range_card_bp(
              title: 'BP',
              Dminmax_Sminmax: normalRangeMap["BP"],
              valueUnit: '',
              iconPath: 'assets/icons/bp_icon.png',
              press: clickBP,
              maxWidth: 235,
              bp_MAP_value: '',
              valueFontSize: fontSize,
            ),
          ],
        ),
      ),
    );
  }
}

class AutoCompleteDrugs extends StatefulWidget {
  @override
  _AutoCompleteDrugsState createState() => _AutoCompleteDrugsState();
}

class _AutoCompleteDrugsState extends State<AutoCompleteDrugs> {
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<Drug>> key = new GlobalKey();
  bool loading = true;
  String selectedMed = "";

  @override
  void initState() {
    getDrugs();
    // TODO: implement initState
    super.initState();
  }

  Widget row(Drug drug) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          drug.brandName,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          drug.genericName,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
          child: loading
              ? CircularProgressIndicator()
              : Row(
                  children: [
                    Flexible(
                      child: searchTextField = AutoCompleteTextField<Drug>(
                        key: key,
                        clearOnSubmit: false,
                        suggestions: GLOBALS.DGURS_LIST,
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                          hintText: "Search/Add Drug",
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                        itemFilter: (item, query) {
                          return item.medQuery
                              .toLowerCase()
                              .contains(query.toLowerCase());
                        },
                        itemSorter: (a, b) {
                          return a.medQuery.compareTo(b.medQuery);
                        },
                        itemSubmitted: (item) {
                          setState(() {
                            if (item.brandName == "-") {
                              searchTextField.textField.controller.text =
                                  item.genericName;
                            } else {
                              searchTextField.textField.controller.text =
                                  item.brandName;
                            }

                            if (searchTextField
                                    .textField.controller.text.length >
                                1) {
                              isTextInSearchField = true;
                            } else {
                              isTextInSearchField = false;
                            }
                          });
                        },
                        itemBuilder: (context, item) {
                          // ui for the autocompelete row
                          return row(item);
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: TextButton(
                        onPressed: () async {
                          if (searchTextField.textField.controller.text.length <
                              1) {
                            makeToast("Diagnosis field can not be empty!");
                          } else {
                            String _drug = searchTextField
                                .textField.controller.text
                                .toLowerCase();
                            _drug = _drug.replaceFirst(
                                _drug[0], _drug[0].toUpperCase());

                            setState(() {
                              PATIENT_INFO.medicationList.add(_drug);
                            });
                            searchTextField.textField.controller.clear();
                            isTextInSearchField = false;
                          }
                        },
                        child: Icon(
                          Icons.add_circle,
                          color: AppColors.deccolor1,
                          size: 50,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Medications",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                    fontSize: 20,
                  )),
              SizedBox(
                height: 5,
              ),
              Wrap(
                children: [
                  for (var item in PATIENT_INFO.medicationList)
                    Stack(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Text(
                              item.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0.0,
                          right: -0.5,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                PATIENT_INFO.medicationList.remove(item);
                              });
                            },
                            child: Icon(
                              Icons.remove_circle,
                              color: AppColors.redButton.withOpacity(.8),
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              // Center(
              //   child: ButtonWidget(
              //     buttonTitle: 'Go back',
              //     // buttonHeight: btn_height,
              //     onTapFunction: () {
              //       Navigator.pop(context, () {
              //         setState(() {});
              //       });
              //     },
              //   ),
              // )
            ],
          ),
        ),
      ],
    );
  }

  getDrugs() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/json/drugs_new.json");
    print(data);

    // final jsonResult = json.decode(data);
    GLOBALS.DGURS_LIST = loadDrugs(data);
    if (GLOBALS.DGURS_LIST.length > 0) {
      setState(() {
        loading = false;
      });
    }
  }

  static List<Drug> loadDrugs(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<Drug>((json) => Drug.fromJson(json)).toList();
  }
}

class AutoCompleteDiagnosis extends StatefulWidget {
  @override
  _AutoCompleteDiagnosis createState() => _AutoCompleteDiagnosis();
}

class _AutoCompleteDiagnosis extends State<AutoCompleteDiagnosis> {
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<Diagnosis>> key = new GlobalKey();
  bool loading = true;
  String selectedMed = "";

  @override
  void initState() {
    getDiagnosis();
    // TODO: implement initState
    super.initState();
  }

  Widget row(Diagnosis diagnosis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          diagnosis.diseaseName,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  getDiagnosis() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/json/diagnosis.json");
    print(data);

    // final jsonResult = json.decode(data);
    GLOBALS.DIAGNOSIS_LIST = loadDiagnosis(data);
    if (GLOBALS.DIAGNOSIS_LIST.length > 0) {
      setState(() {
        loading = false;
      });
    }
  }

  static List<Diagnosis> loadDiagnosis(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<Diagnosis>((json) => Diagnosis.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
          child: loading
              ? CircularProgressIndicator()
              : Row(
                  children: [
                    Flexible(
                      child: searchTextField = AutoCompleteTextField<Diagnosis>(
                        key: key,
                        clearOnSubmit: false,
                        suggestions: GLOBALS.DIAGNOSIS_LIST,
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                          hintText: "Search/Add Diagnosis",
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                        itemFilter: (item, query) {
                          return item.diseaseName
                              .toLowerCase()
                              .contains(query.toLowerCase());
                        },
                        itemSorter: (a, b) {
                          return a.diseaseName.compareTo(b.diseaseName);
                        },
                        itemSubmitted: (item) {
                          setState(() {
                            searchTextField.textField.controller.text =
                                item.diseaseName;
                            // checking if the search bar has texts which not added
                            if (searchTextField
                                    .textField.controller.text.length >
                                1) {
                              isTextInSearchField = true;
                            } else {
                              isTextInSearchField = false;
                            }
                          });
                        },
                        itemBuilder: (context, item) {
                          // ui for the autocompelete row
                          return row(item);
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: TextButton(
                        onPressed: () async {
                          if (searchTextField.textField.controller.text.length <
                              1) {
                            makeToast("Diagnosis field can not be empty!");
                          } else {
                            setState(() {
                              PATIENT_INFO.diagnosisList.add(
                                  searchTextField.textField.controller.text);
                            });
                            searchTextField.textField.controller.clear();
                            isTextInSearchField = false;
                          }
                        },
                        child: Icon(
                          Icons.add_circle,
                          color: AppColors.deccolor1,
                          size: 50,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Diagnoses",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                    fontSize: 20,
                  )),
              SizedBox(
                height: 5,
              ),
              Wrap(
                children: [
                  for (var item in PATIENT_INFO.diagnosisList)
                    Stack(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Text(
                              item.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0.0,
                          right: -0.5,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                PATIENT_INFO.diagnosisList.remove(item);
                              });
                            },
                            child: Icon(
                              Icons.remove_circle,
                              color: AppColors.redButton.withOpacity(.8),
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  navigateTo(BuildContext context, var pageToNavigate) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => pageToNavigate),
    );
    // LoginPage()AbnormalVsBoard
  }
}

final rangeControllerMax = TextEditingController();
final rangeControllerMin = TextEditingController();

class changeNormalRange extends StatelessWidget {
  final String titleText;
  final String vs_key; // HR, RR, SPO2, TEMP, BP
  const changeNormalRange(
      {Key key, this.titleText = "Vital Sign", this.vs_key = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List rangeData = normalRangeMap[vs_key];
    rangeControllerMin.text = rangeData[0].toString();
    rangeControllerMax.text = rangeData[1].toString();

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: Column(
            children: [
              Text(
                "$titleText - Normal Range",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Icon(
                    Icons.arrow_circle_up_rounded,
                    color: AppColors.deccolor1,
                    size: 35,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      controller: rangeControllerMax,
                      decoration: InputDecoration(
                          labelText: 'Maximum Range',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlue))),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.arrow_circle_down_rounded,
                    color: AppColors.deccolor1,
                    size: 35,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      controller: rangeControllerMin,
                      decoration: InputDecoration(
                          labelText: 'Minimum Range',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlue))),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

makeToast(String val) {
  Fluttertoast.showToast(
      msg: val,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 14.0);
}
