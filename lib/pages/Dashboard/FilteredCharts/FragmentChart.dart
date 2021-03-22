import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
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
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: <Widget>[
              Text(titleController.text),
              SizedBox(
                height: 50,
              ),
              FlatButton(
                  color: Colors.blueAccent,
                  onPressed: () {
                    showTitleDialog();
                  },
                  child: Text(
                    'Show Dialog',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
              Text(titleController.text),
            ],
          ),
        ));
  }

  Future showTitleDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Form(
              key: _keyDialogForm,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.ac_unit),
                    ),
                    maxLength: 8,
                    textAlign: TextAlign.center,
                    onSaved: (val) {
                      titleController.text = val;
                      setState(() {
                        print(val);
                      });
                    },
                    autovalidate: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Title Name';
                      }

                      return null;
                    },
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  if (_keyDialogForm.currentState.validate()) {
                    _keyDialogForm.currentState.save();

                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
                color: Colors.blue,
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
            ],
          );
        });
  }
}
