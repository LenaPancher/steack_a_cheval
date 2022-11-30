import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:steack_a_cheval/models/People.dart';

class PeopleService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  signUp(People people) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: people.email,
          password: people.password
      );
      print(userCredential.user);
      String? userId = userCredential.user?.uid;
      people.uid = userId!;
      print(people.toJson());
      await _db.collection("people").add(people.toJson());
      await Future.delayed(Duration(seconds: 2));
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _db.collection("people").doc("NE3BUgyYUMiGUypfUQQr").get();
      print(snapshot.data());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  signIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      print("c'est bon");
      print(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}