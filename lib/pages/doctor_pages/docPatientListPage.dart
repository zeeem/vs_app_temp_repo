import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vital_signs_ui_template/core/configVS.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';
import 'package:vital_signs_ui_template/elements/User.dart';
import 'package:vital_signs_ui_template/elements/patient_tiles.dart';
import 'package:vital_signs_ui_template/pages/doctor_pages/docVSPage.dart';
import 'package:vital_signs_ui_template/pages/doctor_pages/doctor_parient_history.dart';

import '../AlertHomePage.dart';

class docPatientListPage extends StatefulWidget {
  final selectedIndex;

  const docPatientListPage({Key key, this.selectedIndex = 0}) : super(key: key);

  @override
  _docPatientListPage createState() => _docPatientListPage();
}

class _docPatientListPage extends State<docPatientListPage> {
  Future<List<User>> getPatientList() async {
    var data = await http
        .get("https://www.json-generator.com/api/json/get/cetNcbZIuq?indent=2");
    var jsonData = json.decode(data.body);

    List<User> users = [];

    for (var u in jsonData) {
      User user = User(u["index"], u["name"], u["picture"], u["priority"]);

      users.add(user);
    }

    print(users.length);

    doctorData.patientList = users;
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (_selectedIndex == 0) {
        print('index 0');
      } else if (_selectedIndex == 1) {
        print('index 1');
      } else if (_selectedIndex == 2) {
        print('index 2');
      }
    });
  }

  @override
  void initState() {
    //setting the selectedIndex to view tab
    _selectedIndex = widget.selectedIndex;

    getPatientList(); //init the patient list and store as static var
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        height: 130, //no use of this fixed height
        turnOffSettingsButton: true,
        turnOffBackButton: true,
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
            AnimatedSwitcher(
                transitionBuilder: (widget, animation) {
                  return SlideTransition(
                    position:
                        Tween<Offset>(begin: Offset(.5, 0), end: Offset.zero)
                            .animate(animation),
                    child: widget,
                  );
                },
                duration: Duration(milliseconds: 300),
                child: () {
                  switch (_selectedIndex) {
                    case 0:
                      return DoctorPatientListContainer();
                    case 1:
                      return DoctorPatientHistory();
                    case 2:
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        child: contactPatientPage(
                          alert_text: "Who do you want to call?",
                          searchPatientToCall: true,
                        ),
                      );

                    default:
                      return DoctorPatientListContainer();
                  }
                }()),
            // SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            title: Text('History'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_phone_msg_rounded),
            title: Text('Contact'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.deccolor1,
        onTap: _onItemTapped,
      ),
    );
  }
}

class DoctorPatientListContainer extends StatefulWidget {
  @override
  _DoctorPatientListContainerState createState() =>
      _DoctorPatientListContainerState();
}

class _DoctorPatientListContainerState
    extends State<DoctorPatientListContainer> {
  Future<List<User>> _getUsers() async {
    if (doctorData.patientList.length < 1) {
      var data = await http.get(
          "https://www.json-generator.com/api/json/get/cetNcbZIuq?indent=2");
      var jsonData = json.decode(data.body);
      List<User> users = [];
      for (var u in jsonData) {
        User user = User(u["index"], u["name"], u["picture"], u["priority"]);

        users.add(user);
      }
      print(users.length);
      doctorData.patientList = users;
      return users;
    } else {
      return doctorData.patientList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
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
                          Tab(text: 'Abnormal'),
                          Tab(text: 'Borderline'),
                          Tab(text: 'Normal'),
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
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.data == null) {
                                return Container(
                                  child: Center(
                                    child: Text('Loading...'),
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    //checking if priority is 2 (0=low, 1=medium, 2=high)
                                    if (int.tryParse(snapshot
                                            .data[index].priority
                                            .toString()) ==
                                        2) {
                                      return PatientTiles(
                                        title: snapshot.data[index].name,
                                        networkProfilePicture:
                                            snapshot.data[index].picture,
                                        priorityLevel: 2,
                                        onPress: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  docVsVisualizerPage(
                                                      clicked_user:
                                                          snapshot.data[index]),
                                            ),
                                          );
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
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.data == null) {
                                return Container(
                                  child: Center(
                                    child: Text('Loading...'),
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    //checking if priority is 1 (0=low, 1=medium, 2=high)
                                    if (int.tryParse(snapshot
                                            .data[index].priority
                                            .toString()) ==
                                        1) {
                                      return PatientTiles(
                                        title: snapshot.data[index].name,
                                        priorityLevel: 1,
                                        networkProfilePicture:
                                            snapshot.data[index].picture,
                                        onPress: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      docVsVisualizerPage(
                                                          clicked_user: snapshot
                                                              .data[index])));
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
                              // height: MediaQuery.of(context).size.height,
                              //tab 3
                              child: FutureBuilder(
                            future: _getUsers(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.data == null) {
                                return Container(
                                  child: Center(
                                    child: Text('Loading...'),
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    //checking if priority is 0 (0=low, 1=medium, 2=high)
                                    if (int.tryParse(snapshot
                                                .data[index].priority
                                                .toString()) ==
                                            0 ||
                                        int.tryParse(snapshot
                                                .data[index].priority
                                                .toString()) ==
                                            1) {
                                      return PatientTiles(
                                        title: snapshot.data[index].name,
                                        networkProfilePicture:
                                            snapshot.data[index].picture,
                                        priorityLevel: 0,
                                        onPress: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      docVsVisualizerPage(
                                                          clicked_user: snapshot
                                                              .data[index])));
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
    );
  }
}
