import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_app/core/configVS.dart';
import 'package:vital_signs_app/core/consts.dart';
import 'package:vital_signs_app/elements/ButtonWidget.dart';
import 'package:vital_signs_app/elements/CustomAppBar.dart';

import 'configuration_page7.dart';

class ConfigurationPage6 extends StatefulWidget {
  @override
  _ConfigurationPage6 createState() => _ConfigurationPage6();
}

class _ConfigurationPage6 extends State<ConfigurationPage6> {
  Contact _contact3;
  final contact3NameController = TextEditingController();
  final contact3PhoneController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // Future<void> _askPermissions() async {
  //   PermissionStatus permissionStatus = await _getContactPermission();
  //   if (permissionStatus != PermissionStatus.granted) {
  //     _handleInvalidPermissions(permissionStatus);
  //   }
  // }
  //
  // Future<PermissionStatus> _getContactPermission() async {
  //   PermissionStatus permission = await PermissionHandler()
  //       .checkPermissionStatus(PermissionGroup.contacts);
  //   if (permission != PermissionStatus.granted &&
  //       permission != PermissionStatus.disabled) {
  //     Map<PermissionGroup, PermissionStatus> permissionStatus =
  //         await PermissionHandler()
  //             .requestPermissions([PermissionGroup.contacts]);
  //     return permissionStatus[PermissionGroup.contacts] ??
  //         PermissionStatus.unknown;
  //   } else {
  //     return permission;
  //   }
  // }
  //
  // void _handleInvalidPermissions(PermissionStatus permissionStatus) {
  //   if (permissionStatus == PermissionStatus.denied) {
  //     throw PlatformException(
  //         code: "PERMISSION_DENIED",
  //         message: "Access to location data denied",
  //         details: null);
  //   } else if (permissionStatus == PermissionStatus.disabled) {
  //     throw PlatformException(
  //         code: "PERMISSION_DISABLED",
  //         message: "Location data is not available on device",
  //         details: null);
  //   }
  // }
  //
  // Future<void> _pickContact() async {
  //   _askPermissions();
  //   try {
  //     final Contact contact = await ContactsService.openDeviceContactPicker(
  //         iOSLocalizedLabels: iOSLocalizedLabels);
  //     setState(() {
  //       _contact3 = contact;
  //       if (_contact3 != null) {
  //         contact3NameController.text = _contact3.displayName;
  //         contact3PhoneController.text = _contact3.phones.first.value;
  //       }
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

//  getDirLocation() async {
//
//    File file = await File('$path/counter.txt');
//    file.writeAsString('this is test');
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
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
                  Container(
                    padding: EdgeInsets.fromLTRB(50, 0, 50, 0.0),
                    child: Align(
                      child: Image.asset(
                        "assets/images/vs_avatar_01.png",
                        scale: 0.90,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(50, 0, 50, 0.0),
                    child: Text(
                      'Here is your third and last contact in case of emergency.',
                      style: TextStyle(
                          fontSize: 21.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: contact3NameController,
                      decoration: InputDecoration(
                          labelText: 'Name of emergency contact #3',
                          labelStyle: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlue))),
                    ),
                    SizedBox(height: 30.0),
                    TextField(
                      controller: contact3PhoneController,
                      decoration: InputDecoration(
                          labelText: 'Phone number',
                          labelStyle: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlue))),
                    ),
                    SizedBox(height: 30.0),
                  ],
                )),
            FlatButton(
              child: Text(
                'Pick from Contact list',
                style: TextStyle(
                    color: AppColors.deccolor1,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
              // onPressed: _pickContact,
            ),
          ],
        ),
      ),
      bottomNavigationBar: ButtonWidget(
          buttonTitle: 'Next',
          onTapFunction: () {
            //saving PROFILE data in the static vars
            profileData.EMERGENCY_CONTACT_3_NAME = contact3NameController.text;
            profileData.EMERGENCY_CONTACT_3_PHONE =
                contact3PhoneController.text;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ConfigurationPage7(),
              ),
            );
          }),
    );
  }
}
