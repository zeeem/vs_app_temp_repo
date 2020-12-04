import 'package:vital_signs_ui_template/core/configVS.dart';
import 'package:vital_signs_ui_template/elements/ButtonWidget.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:vital_signs_ui_template/elements/User.dart';
import 'package:vital_signs_ui_template/elements/patient_tiles.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:vital_signs_ui_template/pages/doctor_pages/docVSPage.dart';

class docPatientListPage extends StatefulWidget {
  @override
  _docPatientListPage createState() => _docPatientListPage();
}

class _docPatientListPage extends State<docPatientListPage> {
  Future<List<User>> _getUsers() async {
    var data = await http
        .get("http://www.json-generator.com/api/json/get/cetNcbZIuq?indent=2");

    var jsonData = json.decode(data.body);

    List<User> users = [];

    for (var u in jsonData) {
      User user = User(u["index"], u["name"], u["picture"], u["priority"]);

      users.add(user);
    }

    print(users.length);

    return users;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        height: 130, //no use of this fixed height
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  // Container(
                  //   padding: EdgeInsets.fromLTRB(20, 0, 20, 0.0),
                  //   child: Text(
                  //     'Here are your patients\' records',
                  //     style: TextStyle(
                  //         fontSize: 21.0, fontWeight: FontWeight.bold),
                  //     textAlign: TextAlign.left,
                  //   ),
                  // )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  DefaultTabController(
                      length: 3, // length of tabs
                      initialIndex: 0,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              child: TabBar(
                                labelColor: AppColors.deccolor1,
                                unselectedLabelColor: Colors.black,
                                tabs: [
                                  Tab(text: 'High Risk'),
                                  Tab(text: 'Medium Risk'),
                                  Tab(text: 'Low Risk'),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Container(
                                height: 600, //height of TabBarView
                                decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: Colors.grey, width: 0.5))),
                                child: TabBarView(children: <Widget>[
                                  Container(
                                      //tab 1
                                      child: FutureBuilder(
                                    future: _getUsers(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.data == null) {
                                        return Container(
                                          child: Center(
                                            child: Text('Loading...'),
                                          ),
                                        );
                                      } else {
                                        return ListView.builder(
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            //checking if priority is 2 (0=low, 1=medium, 2=high)
                                            if (int.tryParse(snapshot
                                                    .data[index].priority
                                                    .toString()) ==
                                                2) {
                                              return PatientTiles(
                                                title:
                                                    snapshot.data[index].name,
                                                networkProfilePicture: snapshot
                                                    .data[index].picture,
                                                priorityLevel: 2,
                                                onPress: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              docVsVisualizerPage(
                                                                  clicked_user:
                                                                      snapshot.data[
                                                                          index])));
                                                },
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        );
                                      }
                                    },
                                  )),
                                  Container(
                                      //tab 2
                                      child: FutureBuilder(
                                    future: _getUsers(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.data == null) {
                                        return Container(
                                          child: Center(
                                            child: Text('Loading...'),
                                          ),
                                        );
                                      } else {
                                        return ListView.builder(
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            //checking if priority is 1 (0=low, 1=medium, 2=high)
                                            if (int.tryParse(snapshot
                                                    .data[index].priority
                                                    .toString()) ==
                                                1) {
                                              return PatientTiles(
                                                title:
                                                    snapshot.data[index].name,
                                                networkProfilePicture: snapshot
                                                    .data[index].picture,
                                                onPress: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              docVsVisualizerPage(
                                                                  clicked_user:
                                                                      snapshot.data[
                                                                          index])));
                                                },
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        );
                                      }
                                    },
                                  )),
                                  Container(
                                      //tab 3
                                      child: FutureBuilder(
                                    future: _getUsers(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.data == null) {
                                        return Container(
                                          child: Center(
                                            child: Text('Loading...'),
                                          ),
                                        );
                                      } else {
                                        return ListView.builder(
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            //checking if priority is 0 (0=low, 1=medium, 2=high)
                                            if (int.tryParse(snapshot
                                                    .data[index].priority
                                                    .toString()) ==
                                                0) {
                                              return PatientTiles(
                                                title:
                                                    snapshot.data[index].name,
                                                networkProfilePicture: snapshot
                                                    .data[index].picture,
                                                onPress: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              docVsVisualizerPage(
                                                                  clicked_user:
                                                                      snapshot.data[
                                                                          index])));
                                                },
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        );
                                      }
                                    },
                                  )),
                                ]))
                          ])),
                  // SizedBox(height: 30.0),
                ],
              ),
            ),
            // SizedBox(height: 30),
          ],
        ),
      ),
      // bottomNavigationBar: ButtonWidget(
      //   buttonTitle: 'Next',
      //   onTapFunction: () {
      //     Navigator.of(context).push(
      //       MaterialPageRoute(
      //           // builder: (_) => ConfigurationPage3(),
      //           ),
      //     );
      //   },
      // ),
    );
  }
}
