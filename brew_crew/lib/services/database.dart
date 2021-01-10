import 'package:brew_crew/models/User.dart';
import 'package:brew_crew/models/brew.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  //

  final String uid;

  DatabaseService({this.uid});

  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection("brews");

  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  // brew list from snapshit

  List<Brew> _brewListFromSnaphshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => Brew(
            name: doc.data()['name'] ?? '',
            strength: doc.data()['strength'] ?? 0,
            sugars: doc.data()['sugars'] ?? '0'))
        .toList();
  }

  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnaphshot);
  }

  Stream<DocumentSnapshot> get userDataSnapshots {
    return brewCollection.doc(uid).snapshots();
  }

  Stream<UserData> get userData {
    return userDataSnapshots.map(_userDataFromSnapShot);
  }

  UserData _userDataFromSnapShot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data()['name'],
      sugars: snapshot.data()['sugars'],
      strength: snapshot.data()['strength'],
    );
  }
}
