import 'package:flutter/material.dart';
import 'package:steack_a_cheval/api/horse_service.dart';
import 'package:steack_a_cheval/api/people_service.dart';
import 'package:steack_a_cheval/models/Horse.dart';
import 'package:steack_a_cheval/models/People.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum HorseStatus {
  isMine,
  isOtherPeople,
  isFree,
}

class HorseDpPage extends StatefulWidget {
  static const tag = "horse_dp";

  final People currentPeople;

  const HorseDpPage({Key? key, required this.currentPeople}) : super(key: key);

  @override
  State<HorseDpPage> createState() => _HorseDpPageState();
}

class _HorseDpPageState extends State<HorseDpPage> {
  HorseService horseService = HorseService();
  late Future<List<Horse>> listHorse;
  PeopleService peopleService = PeopleService();
  late Future<People> currentPeople;

  @override
  void initState() {
    listHorse = horseService.getHorses();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chevaux"),
      ),
      body: FutureBuilder<List<Horse>>(
          future: listHorse,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Horse> horses = snapshot.data!;
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: horses.length,
                  itemBuilder: (context, index) {
                    final horse = horses[index];
                    HorseStatus horseStatus = getHorseStatus(horse);
                    return horseStatus == HorseStatus.isMine ?
                    Slidable(
                      key: const ValueKey(0),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (BuildContext context) async {
                              horse.userId = "";
                              await horseService.updateHorse(horse);
                              setState(() {});
                              var snackBar = SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text('Au revoir ${horse.name} !'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            },
                            backgroundColor: Color(0xFFA73322),
                            foregroundColor: Colors.white,
                            icon: Icons.remove,
                          ),
                        ],
                      ), child: cardBoxHorse(horse: horse, horseStatus: horseStatus),
                    )
                        : cardBoxHorse(horse: horse, horseStatus: horseStatus);
                  });
            } else if (snapshot.hasError) {
              return Text("An error occured :${snapshot.error}");
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget cardBoxHorse({required Horse horse, required HorseStatus horseStatus}) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: 120,
      width: size.width,
      child: GestureDetector(
        onTap: () async {
          bool hasAlreadyHorse = await horseService.getHorseSizeByUserId(widget.currentPeople);
          if (horseStatus == HorseStatus.isFree && !hasAlreadyHorse) {
            dialogBuilder(horse);
          } else {
            null;
          }
        },
        child: Card(
          elevation: 1,
          color: getCardHorseColor(horseStatus),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          horse.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        Text(
                          " (${horse.sexe})",
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    Text("Age : ${horse.age} ans"),
                    Text("Race : ${horse.race}"),
                    Text("Couleur : ${horse.robe}"),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(horse.speciality),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color getCardHorseColor(HorseStatus horseStatus) {
    switch (horseStatus) {
      case HorseStatus.isMine:
        return Colors.green.shade200;
      case HorseStatus.isOtherPeople:
        return Colors.red.shade200;
      default:
        return Color(0xFFEDEDED);
    }
  }

  Future<void> dialogBuilder(Horse horse) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("S'associer à un cheval"),
          content: Text("Vous êtes sur le point de vous associer à ${horse.name}."),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text("Confirmer"),
              onPressed: () async {
                horse.userId = widget.currentPeople.uid;
                await horseService.updateHorse(horse);
                setState(() {});
                Navigator.of(context).pop();
                const snackBar = SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text('Félicitation !'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }

  HorseStatus getHorseStatus(Horse horse) {
    bool isMine = horse.userId == widget.currentPeople.uid;
    if (horse.userId.isEmpty) {
      return HorseStatus.isFree;
    } else if (isMine) {
      return HorseStatus.isMine;
    } else {
      return HorseStatus.isOtherPeople;
    }
  }
}
