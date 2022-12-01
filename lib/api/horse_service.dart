import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:steack_a_cheval/models/Horse.dart';

class HorseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Horse> listHorse = [];

  Future<List<Horse>> getHorses() async {
    QuerySnapshot snapshot = await _db
        .collection('horse')
        .get();

    for (var i = 0; i < snapshot.docs.length; i++) {
      final horseJson = snapshot.docs[i].data() as Map<String, dynamic>;
      Horse horse = Horse.fromJson(horseJson);
      listHorse.add(horse);
    }

    return listHorse;
  }


}
