import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:steack_a_cheval/models/Concours.dart';
import 'package:steack_a_cheval/models/Cours.dart';

class CoursService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> insertCours(Cours cours) async {
    try {
      await _db.collection("cours").add(cours.toJson());
    } on FirebaseAuthException catch (e) {
      throw Exception("Problème d'insertion");
    }
  }

  Future<List<Cours>> getCoursByUserId(String id) async {
    QuerySnapshot snapshot =
    await _db.collection('cours').where("owner", isEqualTo: id).get();
    List<Cours> cours = [];

    for (var element in snapshot.docs) {
      cours.add(Cours.fromJson(element.data() as Map<String, dynamic>));
    }

    return cours;
  }

  Future<List<Cours>> getCours() async {
    List<Cours> listCours = [];

    QuerySnapshot snapshot = await _db
        .collection('cours')
        .get();

    for (var i = 0; i < snapshot.docs.length; i++) {
      final coursJson = snapshot.docs[i].data() as Map<String, dynamic>;
      Cours cours = Cours.fromJson(coursJson);
      print(cours);
      listCours.add(cours);
    }

    return listCours;
  }

}