import 'package:brew_crew/models/User.dart';
import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:flutter/material.dart';

class SettingsForm extends StatefulWidget {
  final Brew brew;
  final String uid;

  const SettingsForm({Key key, this.brew, this.uid}) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentName = widget.brew.name;

    _currentSugars = widget.brew.sugars;

    _currentStrength = widget.brew.strength;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          //
          Text(
            "Update your brew settings.",
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            decoration: textInputDecoration,
            initialValue: _currentName,
            validator: (val) => val.isEmpty ? 'Please enter a name' : null,
            onChanged: (val) => setState(() => _currentName = val),
          ),
          SizedBox(height: 20.0),
          //dropdown
          DropdownButtonFormField(
            decoration: textInputDecoration,
            value: _currentSugars,
            items: sugars
                .map((v) => DropdownMenuItem<String>(
                      value: v,
                      child: Text("$v sugars"),
                    ))
                .toList(),
            onChanged: (String newSugars) {
              setState(() {
                _currentSugars = newSugars;
              });
            },
          ),
          //slider
          Slider(
            activeColor: Colors.brown[_currentStrength],
            inactiveColor: Colors.brown[_currentStrength],
            min: 100,
            max: 900,
            value: _currentStrength.toDouble(),
            divisions: 8,
            onChanged: (val) => setState(() {
              _currentStrength = val.round();
              print(_currentStrength);
            }),
          ),
          RaisedButton(
            color: Colors.pink[400],
            child: Text(
              "Update",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                //
                await DatabaseService(uid: widget.uid).updateUserData(
                    _currentSugars, _currentName, _currentStrength);
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
    );
  }
}
