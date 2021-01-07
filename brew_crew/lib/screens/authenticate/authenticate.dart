import 'package:brew_crew/screens/authenticate/register.dart';
import 'package:brew_crew/screens/authenticate/sign_in.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool signIn = true;

  void toggleView() {
    setState(() {
      signIn = !signIn;
    });
  }

  final AuthService _auth = AuthService();

  String email = "";
  String password = "";

  String getAppBarText() {
    return signIn ? "Sign in to Brew Crew" : "Sign up to Brew Crew";
  }

  String getSubmitButtonText() {
    return signIn ? "Sign in" : "Register";
  }

  String getToggleSignInButtonText() {
    return signIn ? "Register" : "Sign In";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          title: Text(getAppBarText()),
          actions: <Widget>[
            FlatButton.icon(
                onPressed: toggleView,
                icon: Icon(Icons.person),
                label: Text(getToggleSignInButtonText()))
          ]),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          child: Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                onChanged: (val) => email = val,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                obscureText: true,
                onChanged: (val) => password = val,
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                  color: Colors.pink[400],
                  child: Text(getSubmitButtonText(),
                      style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    print(email);
                    print(password);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
