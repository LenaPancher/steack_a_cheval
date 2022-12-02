import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:steack_a_cheval/models/Horse.dart';
import 'package:steack_a_cheval/models/People.dart';

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

  Future updateHorse(Horse horse) async {
    QuerySnapshot snapshot = (await _db
        .collection('horse')
        .where("horse_id", isEqualTo: horse.horseId).get());
    var horseUpdate = snapshot.docs[0].reference.update(horse.toJson());
    print("HORSEEE === $horseUpdate");
  }

  Future<bool> getHorseSizeByUserId(People people) async {
    QuerySnapshot snapshot = (await _db
        .collection('horse')
        .where("user_id", isEqualTo: people.uid).get());

    var horseSize = snapshot.docs.length;
    print("HORSEEE  SIZEEEE === $horseSize");
    if (horseSize >= 1) {
      return true;
    } return false;
  }
}
