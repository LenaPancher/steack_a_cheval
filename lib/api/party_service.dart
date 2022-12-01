import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:steack_a_cheval/models/People.dart';

import '../models/Party.dart';
import 'exceptions.dart';

class PartyService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> insertParty(Party party) async {

    try {
      await _db.collection("parties").add(party.toJson());

    } on FirebaseAuthException catch (e) {
      throw SteakException(message: "Problème d'insertion");

    }
  }



}
