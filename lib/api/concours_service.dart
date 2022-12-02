import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:steack_a_cheval/api/exceptions.dart';
import 'package:steack_a_cheval/models/Concours.dart';
import 'package:steack_a_cheval/models/People.dart';

class ConcourService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Concours> listConcours = [];

  Future<List<Concours>> getConcours() async {
    QuerySnapshot snapshot = await _db.collection('concours').get();

    for (var i = 0; i < snapshot.docs.length; i++) {
      final concoursJson = snapshot.docs[i].data() as Map<String, dynamic>;
      Concours concours = Concours.fromJson(concoursJson);
      listConcours.add(concours);
      print("CONCOURS = $listConcours");
    }

    return listConcours;
  }

  Future<void> insertConcours(Concours concours) async {
    try {
      await _db.collection("concours").add(concours.toJson());
    } on FirebaseException catch (e) {
      throw SteakException(message: "Problème d'insertion");
    }
  }

  // Future updateConcours(Concours concours) async {
  //   QuerySnapshot snapshot = await _db
  //       .collection('concours')
  //       .where("firebase_id", isEqualTo: FirebaseAuth.instance.currentUser?.uid).get();
  //   var user = snapshot.docs[0].reference.update(people.toJson());
  //   print("USER === $user");
  // }
}
