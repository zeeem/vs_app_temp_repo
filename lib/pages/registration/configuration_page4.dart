import 'package:vital_signs_ui_template/core/configVS.dart';
import 'package:vital_signs_ui_template/elements/ButtonWidget.dart';
import 'package:vital_signs_ui_template/elements/CustomAppBar.dart';

import 'configuration_page5.dart';
import 'package:flutter/material.dart';
import 'package:vital_signs_ui_template/core/consts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/services.dart';

const iOSLocalizedLabels = false;

class ConfigurationPage4 extends StatefulWidget {
  @override
  _ConfigurationPage4 createState() => _ConfigurationPage4();
}

class _ConfigurationPage4 extends State<ConfigurationPage4> {
  Contact _contact;
  final Contact1NameController = TextEditingController();
  final Contact1PhoneController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus != PermissionStatus.granted) {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      throw PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to location data denied",
          details: null);
    } else if (permissionStatus == PermissionStatus.disabled) {
      throw PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }

  Future<void> _pickContact() async {
    _askPermissions();
    try {
      final Contact contact = await ContactsService.openDeviceContactPicker(
          iOSLocalizedLabels: iOSLocalizedLabels);
      setState(() {
        _contact = contact;
        if (_contact != null) {
          Contact1NameController.text = _contact.displayName;
          Contact1PhoneController.text = _contact.phones.first.value;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
                        scale: 0.75,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(40, 0, 40, 0.0),
                    child: Text(
                      'In the case of an emergency, we will add up to three persons that the app can quickly call in case you need help.',
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
                      controller: Contact1NameController,
                      decoration: InputDecoration(
                          labelText: 'Name of emergency contact #1',
                          labelStyle: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlue))),
                    ),
                    SizedBox(height: 30.0),
                    TextField(
                      controller: Contact1PhoneController,
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
//            SizedBox(height: 10),
            FlatButton(
              child: Text(
                'Pick from Contact list',
                style: TextStyle(
                    color: AppColors.deccolor1,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
              onPressed: _pickContact,
            ),

            //_contact.displayName
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: ButtonWidget(
          buttonTitle: 'Next',
          onTapFunction: () {
            //saving PROFILE data in the static vars
            profileData.EMERGENCY_CONTACT_1_NAME = Contact1NameController.text;
            profileData.EMERGENCY_CONTACT_1_PHONE =
                Contact1PhoneController.text;

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ConfigurationPage5(),
              ),
            );
          },
        ),
      ),
    );
  }
}
