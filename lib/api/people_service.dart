import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:steack_a_cheval/models/Cours.dart';
import 'package:steack_a_cheval/models/People.dart';

import 'exceptions.dart';

class PeopleService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserCredential> signUp(People people) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: people.email, password: people.password);
      String? userId = userCredential.user?.uid;
      people.uid = userId!;
      await _db.collection("people").add(people.toJson());
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw SteakException(message: 'Mot de passe trop faible.');
      } else if (e.code == 'email-already-in-use') {
        throw SteakException(message: 'Adresse mail déjà utilisé.');
      } else {
        throw SteakException(message: 'Impossible de s\'inscrire');
      }
    } catch (e) {
      throw SteakException(message: 'Impossible de s\'inscrire');
    }
  }

  Future<UserCredential> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw SteakException(message: 'Utilisateur non trouvé.');
      } else if (e.code == 'wrong-password') {
        throw SteakException(message: 'Mot de passe incorect.');
      } else {
        throw SteakException(message: 'Impossible de se connecter ');
      }
    }
  }

  Future<People> currentUser() async {
    if (FirebaseAuth.instance.currentUser != null) {
      QuerySnapshot snapshot = await _db
          .collection('people')
          .where("firebase_id",
              isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();

      final peopleJson = snapshot.docs[0].data() as Map<String, dynamic>;
      People currentPeople = People.fromJson(peopleJson);
      return currentPeople;
    }
    throw SteakException(message: 'Impossible de trouver le user :(');
  }

  Future updateProfile(People people) async {
    QuerySnapshot snapshot = await _db
        .collection('people')
        .where("firebase_id", isEqualTo: FirebaseAuth.instance.currentUser?.uid).get();
    var user = snapshot.docs[0].reference.update(people.toJson());
  }

  Future<List<People>> getAllParticipant(List<dynamic> idList) async {
    List<People> peopleList = [];
    if(idList.isEmpty){
      return peopleList;
    }
    for (var i=0; i<idList.length; i++){
      QuerySnapshot snapshot = (await _db
          .collection('people')
          .where ("firebase_id", isEqualTo: idList[i]).get());

    var peopleJson = snapshot.docs[i].data() as Map<String, dynamic>;
    People people = People.fromJson(peopleJson);
    peopleList.add(people);
    }

    return peopleList;

  }
}