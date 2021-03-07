import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vital_signs_ui_template/Processing/NetworkGateway/networkManager.dart';
import 'package:vital_signs_ui_template/core/configVS.dart';
import 'package:vital_signs_ui_template/elements/User.dart';

class TestAPI extends StatefulWidget {
  @override
  _TestAPIState createState() => _TestAPIState();
}

class _TestAPIState extends State<TestAPI> {
  String username = 'testuservs';
  String password = 'Apple';

  DateTime now;

  @override
  Future<void> initState() {
    // login_and_print();

    super.initState();
  }

  login_and_print() async {
    int statusCode = await logIntoAccount(username, password);
    print(statusCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      onPressed: () async {
                        await login_and_print();
                      },
                      child: Text('LOG IN'),
                    ),
                    RaisedButton(
                      onPressed: () async {
                        String logOutText = await logoutAccount();
                        print(logOutText);
                      },
                      child: Text('LOG OUT'),
                    ),
                  ],
                ),
                RaisedButton(
                    onPressed: () {
                      setState(() {
                        now = DateTime.now();
                        DateTime timeFrom =
                            DateTime.now().subtract(Duration(days: 2)).toUtc();
                        DateTime timeTo =
                            DateTime.now().subtract(Duration(days: 1)).toUtc();

                        fetchVSData(timeFrom, timeTo, 'day');
                        print("TIME_FROM = $timeFrom");
                        print("TIME_TO = $timeTo");
                      });
                    },
                    child: Text('TEST')),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(50),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38, width: 2)),
                child: Text(
                  now.toString(),
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

Future<int> logIntoAccount(String username, String password) async {
  NetworkManager apiNetworkManager = GLOBALS.API_NETWORK_MANAGER;
  Map<String, dynamic> loginMap = {
    "username": "$username",
    "password": "$password"
  };

  var response =
      await apiNetworkManager.request('POST', '/api/login/', body: loginMap);
  if (response.statusCode == 200) {
    var mappedResponse = jsonDecode(response.body);
    profileData.userUUID = mappedResponse['id'];
  }
  // print(response.body);
  print('logged in! id:');
  GLOBALS.USER_PROFILE = await getUserProfile(response);
  print(GLOBALS.USER_PROFILE.id);

  return response.statusCode;
}

Future<String> logoutAccount() async {
  NetworkManager apiNetworkManager = GLOBALS.API_NETWORK_MANAGER;

  Map<String, dynamic> logoutMap = {};

  var response =
      await apiNetworkManager.request('POST', '/api/logout/', body: logoutMap);
  if (response.statusCode == 200) {
    // var mappedResponse = jsonDecode(response.body);
    // profileData.userUUID = mappedResponse['id'];
    print('logout done!');
  }
  print(response.body);

  return response.body;
}

Future<String> fetchVSData(
    DateTime timeFrom, DateTime timeTo, String type) async {
  NetworkManager apiNetworkManager = GLOBALS.API_NETWORK_MANAGER;

  String api_target =
      "/api/vitalsign/${GLOBALS.USER_PROFILE.id}/?from=$timeFrom&to=$timeTo&type=$type";
  print('API_TARGET = $api_target');
  var response = await apiNetworkManager.request('GET', api_target);
  if (response.statusCode == 200) {
    var mappedResponse = jsonDecode(response.body);
    print(mappedResponse);
  }
  print(response.body);
}

Future<UserProfile> getUserProfile(http.Response response) async {
  var data = response;
  var u = json.decode(data.body);
  UserProfile userProfile = UserProfile(
      u["id"],
      u["first_name"],
      u["last_name"],
      u["user_type"],
      u["gender"],
      DateTime.tryParse(u["date_joined"]),
      DateTime.tryParse(u["date_of_birth"]),
      u["phone"],
      u["email"]);

  return userProfile;
}
