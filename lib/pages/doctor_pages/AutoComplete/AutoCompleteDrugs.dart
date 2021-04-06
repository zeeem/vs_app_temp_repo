import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/configVS.dart';
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
        children: <Widget>[
          loading
              ? CircularProgressIndicator()
              : searchTextField = AutoCompleteTextField<Drug>(
                  key: key,
                  clearOnSubmit: false,
                  suggestions: GLOBALS.DGURS_LIST,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                    hintText: "Search Drug",
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
          ElevatedButton(
            onPressed: () {
              setState(() {
                PATIENT_INFO.medicationList
                    .add(searchTextField.textField.controller.text);
              });
            },
            child: Text('Add'),
          )
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
