import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:steack_a_cheval/models/Concours.dart';
import 'package:steack_a_cheval/models/Cours.dart';
import 'package:steack_a_cheval/models/Party.dart';
import 'package:steack_a_cheval/models/People.dart';

class FeedService{

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<People>> getPeoples() async {
    List<People> listPeople = [];

    QuerySnapshot snapshot = await _db
        .collection('people')
        .get();

    for (var i = 0; i < snapshot.docs.length; i++) {
      final peopleJson = snapshot.docs[i].data() as Map<String, dynamic>;
      People peoples = People.fromJson(peopleJson);
      print(peoples);
      listPeople.add(peoples);
    }

    return listPeople;
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

  Future<List<Concours>> getConcours() async {
    List<Concours> listConcours = [];

    QuerySnapshot snapshot = await _db
        .collection('concours')
        .get();

    for (var i = 0; i < snapshot.docs.length; i++) {
      final concoursJson = snapshot.docs[i].data() as Map<String, dynamic>;
      Concours concours = Concours.fromJson(concoursJson);
      print(concours);
      listConcours.add(concours);
    }

    return listConcours;
  }

  Future<List<Party>> getParties() async {
    List<Party> listParties = [];

    QuerySnapshot snapshot = await _db
        .collection('parties')
        .get();

    for (var i = 0; i < snapshot.docs.length; i++) {
      final partiesJson = snapshot.docs[i].data() as Map<String, dynamic>;
      Party parties = Party.fromJson(partiesJson);
      print(parties);
      listParties.add(parties);
    }

    return listParties;
  }

}