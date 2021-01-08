import 'package:brew_crew/screens/authenticate/register.dart';
import 'package:brew_crew/screens/authenticate/sign_in.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool isSignIn = true;

  bool loading = false;

  void toggleView() {
    setState(() {
      error = "";
      isSignIn = !isSignIn;
    });
  }

  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String error = "";
  String getAppBarText() {
    return isSignIn ? "Sign in to Brew Crew" : "Sign up to Brew Crew";
  }

  String getSubmitButtonText() {
    return isSignIn ? "Sign in" : "Register";
  }

  String getToggleSignInButtonText() {
    return isSignIn ? "Register" : "Sign In";
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
      body: loading
          ? Loading()
          : Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: "Email"),
                      validator: (val) => val.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) => email = val,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: "Password"),
                      validator: (val) => val.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null,
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
                      onPressed: isSignIn ? signIn : register,
                    ),
                    SizedBox(height: 12.0),
                    Text(error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0)),
                  ],
                ),
              ),
            ),
    );
  }

  register() async {
    if (_formKey.currentState.validate()) {
      setState(() => loading = true);
      dynamic result =
          await _auth.registerWithEmailAndPassword(email, password);
      setState(() => loading = false);

      if (result == null) {
        setState(() => error = 'please supply a valid email');
      }

      print(email);
      print(password);
    }
  }

  signIn() async {
    if (_formKey.currentState.validate()) {
      setState(() => loading = true);

      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
      setState(() => loading = false);

      if (result == null) {
        setState(() => error = 'COULD NOT SIGN IN WITH THOSE CREDENTIALS');
      }

      print(email);
      print(password);
    }
  }
}
