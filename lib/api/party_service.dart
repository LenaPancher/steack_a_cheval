import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:steack_a_cheval/models/People.dart';

import '../models/Party.dart';
import 'exceptions.dart';

class PartyService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Party> partyList = [];

  Future<void> insertParty(Party party) async {
    try {
      await _db.collection("parties").add(party.toJson());
    } on FirebaseAuthException catch (e) {
      throw SteakException(message: "Problème d'insertion");
    }
  }

  Future<List<Party>> getAllParties() async {
    QuerySnapshot snapshot = await _db.collection('parties').orderBy("createdAt", descending: true).get();

    for (var i = 0; i < snapshot.docs.length; i++) {
      final partyJson = snapshot.docs[i].data() as Map<String, dynamic>;
      Party party = Party.fromJson(partyJson);
      partyList.add(party);
    }
    return partyList;
  }
}
