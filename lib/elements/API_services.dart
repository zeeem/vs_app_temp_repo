import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Processing/NetworkGateway/networkManager.dart';
import '../core/configVS.dart';
import 'User.dart';

class API_SERVICES {
  static Future<int> logIntoAccount(String username, String password) async {
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

  static Future<String> logoutAccount() async {
    NetworkManager apiNetworkManager = GLOBALS.API_NETWORK_MANAGER;

    Map<String, dynamic> logoutMap = {};

    var response = await apiNetworkManager.request('POST', '/api/logout/',
        body: logoutMap);
    if (response.statusCode == 200) {
      // var mappedResponse = jsonDecode(response.body);
      // profileData.userUUID = mappedResponse['id'];
      print('logout done!');
    }
    print(response.body);

    return response.body;
  }

  static Future<dynamic> fetchVSData(
      DateTime timeFrom, DateTime timeTo, String vsTimeScale) async {
    NetworkManager apiNetworkManager = GLOBALS.API_NETWORK_MANAGER;
    List out;
    // if (GLOBALS.USER_PROFILE.id == null) {
    //   String username = 'testuservs';
    //   String password = 'Apple';
    //   int statusCode = await logIntoAccount(username, password);
    //   print(statusCode);
    // }
    String api_target =
        "/api/vitalsign/${GLOBALS.USER_PROFILE.id}/?from=$timeFrom&to=$timeTo&type=$vsTimeScale";
    print('API_TARGET = $api_target');
    var response = await apiNetworkManager.request('GET', api_target);
    if (response.statusCode == 200) {
      var mappedResponse = jsonDecode(response.body);
      out = mappedResponse;
      GLOBALS.FETCHED_RESPONSE = out;
      print(out.length);
    }
    print(response.body);
    return out;
  }

  static Future<UserProfile> getUserProfile(http.Response response) async {
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
}
