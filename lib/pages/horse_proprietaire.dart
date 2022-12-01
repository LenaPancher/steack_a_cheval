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

class HorseProprietairePage extends StatefulWidget {
  static const tag = "horse_proprietaire";

  final People currentPeople;

  const HorseProprietairePage({Key? key, required this.currentPeople}) : super(key: key);

  @override
  State<HorseProprietairePage> createState() => _HorseProprietairePageState();
}

class _HorseProprietairePageState extends State<HorseProprietairePage> {
  HorseService horseService = HorseService();
  late Future<List<Horse>> listHorse;
  PeopleService peopleService = PeopleService();
  late Future<People> currentPeople;
  final _formKey = GlobalKey<FormState>();
  String sexeChoice = "";
  String specialityChoice = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController raceController = TextEditingController();
  TextEditingController robeController = TextEditingController();

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
        onTap: () {
          if (horseStatus == HorseStatus.isFree) {
            dialogBuilder(horse);
          } else if (horseStatus == HorseStatus.isMine) {
            updateControllers(horse);
            dialogBuilderEdit(horse);
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
          title: const Text("Devenir propriétaire"),
          content: Text("Vous êtes sur le point de devenir le propriétaire de ${horse.name}."),
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

  Future<void> dialogBuilderEdit(Horse horse) {
    setState(() {
      sexeChoice = horse.sexe;
      specialityChoice = horse.speciality;
    });
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier mon cheval'),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    fieldForm(
                        controller: nameController,
                        hint: "Nom",
                        type: TextInputType.text),
                    choiceSexe(setState),
                    fieldForm(
                        controller: ageController,
                        hint: "Âge",
                        type: TextInputType.number),
                    fieldForm(
                        controller: raceController,
                        hint: "Race",
                        type: TextInputType.text),
                    fieldForm(
                        controller: robeController,
                        hint: "Couleur",
                        type: TextInputType.text),
                    choiceSpeciality(setState),
                  ],
                ),
              ),
            );
          }),
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
              child: const Text('Valider'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  horse.name = nameController.text;
                  horse.age = ageController.text;
                  horse.robe = robeController.text;
                  horse.race = raceController.text;
                  horse.sexe = sexeChoice;
                  horse.speciality = specialityChoice;
                  await horseService.updateHorse(horse);
                  setState(() {});
                  Navigator.of(context).pop();
                }
                const snackBar = SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text('Modification effectuée !'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }

  TextFormField fieldForm(
      {required TextEditingController controller,
      required String hint,
      required TextInputType type}) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ce champ est obligatoire';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
      ),
    );
  }

  Column choiceSexe(StateSetter setState) {
    List<Widget> widget = [];
    List<String> sexe = ["Femelle", "Mâle"];
    for (var i = 0; i < sexe.length; i++) {
      ListTile sizedBox = ListTile(
        contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
        title: Text(sexe[i]),
        leading: Radio<String>(
          activeColor: const Color(0xFFA73322),
          value: sexe[i],
          groupValue: sexeChoice,
          onChanged: (newValue) {
            setState(() {
              sexeChoice = newValue!;
            });
          },
        ),
      );
      widget.add(sizedBox);
    }
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: widget,
    );
  }

  Column choiceSpeciality(StateSetter setState) {
    print("speciality choice = $specialityChoice");
    List<Widget> widget = [];
    List<String> speciality = [
      "Endurance",
      "Saut d'obstacle",
      "Complet",
      "Dressage"
    ];
    for (var i = 0; i < speciality.length; i++) {
      ListTile sizedBox = ListTile(
        contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
        title: Text(speciality[i]),
        leading: Radio<String>(
          activeColor: const Color(0xFFA73322),
          value: speciality[i],
          groupValue: specialityChoice,
          onChanged: (newValue) {
            setState(() {
              specialityChoice = newValue!;
            });
          },
        ),
      );
      widget.add(sizedBox);
    }
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: widget,
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

  void updateControllers(Horse horse) {
    nameController.text = horse.name;
    ageController.text = horse.age;
    raceController.text = horse.race;
    robeController.text = horse.robe;
  }
}
