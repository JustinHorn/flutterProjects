import 'package:brew_crew/models/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj based on Firebase.User

  CostumUser _costumUserFromUser(User user) {
    return user != null ? CostumUser(uid: user.uid) : null;
  }

  Stream<CostumUser> get user {
    return _auth.authStateChanges().map(_costumUserFromUser);
  }

  // sign in anonymously

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();

      User user = result.user;
      return _costumUserFromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _costumUserFromUser(user);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _costumUserFromUser(user);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //signout

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
