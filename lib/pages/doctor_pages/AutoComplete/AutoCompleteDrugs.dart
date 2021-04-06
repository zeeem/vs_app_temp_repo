import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/configVS.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:vital_signs_ui_template/elements/ButtonWidget.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';

import '../../../core/configVS.dart';
import 'Drug.dart';

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
    return Scaffold(
      appBar: CustomAppBar(
        height: 120,
        turnOffBackButton: true,
        turnOffSettingsButton: true,
      ),
      body: Column(
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
                            return item.brandName
                                .toLowerCase()
                                .startsWith(query.toLowerCase());
                          },
                          itemSorter: (a, b) {
                            return a.brandName.compareTo(b.brandName);
                          },
                          itemSubmitted: (item) {
                            setState(() {
                              searchTextField.textField.controller.text =
                                  item.brandName;
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
                          onPressed: () {
                            if (searchTextField
                                    .textField.controller.text.length <
                                1) {
                              print("ERROR");
                            } else {
                              setState(() {
                                PATIENT_INFO.medicationList.add(
                                    searchTextField.textField.controller.text);
                              });
                              searchTextField.textField.controller.clear();
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
                      )
                  ],
                ),
                Center(
                  child: ButtonWidget(
                    buttonTitle: 'Go back',
                    // buttonHeight: btn_height,
                    onTapFunction: () {
                      Navigator.pop(context, () {
                        setState(() {});
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  getDrugs() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/json/drugs.json");
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
