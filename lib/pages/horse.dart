import 'package:flutter/material.dart';
import 'package:steack_a_cheval/api/horse_service.dart';
import 'package:steack_a_cheval/models/Horse.dart';

class HorsePage extends StatefulWidget {
  static const tag = "horse";

  const HorsePage({Key? key}) : super(key: key);

  @override
  State<HorsePage> createState() => _HorsePageState();
}

class _HorsePageState extends State<HorsePage> {
  HorseService horseService = HorseService();
  late Future<List<Horse>> listHorse;

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
                    return cardBoxHorse(horse: horses[index]);
                  });
            } else if (snapshot.hasError) {
              return Text("An error occured :${snapshot.error}");
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget cardBoxHorse({required Horse horse}) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: 120,
      width: size.width,
      child: GestureDetector(
        onTap: () => dialogBuilder(context, horse),
        child: Card(
          elevation: 1,
          color: Color(0xFFEDEDED),
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

  Future<void> dialogBuilder(BuildContext context, Horse horse) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("S'associer à un cheval"),
          content: const Text(
              "Information : Si vous êtes demi pensionnaire vous ne pouvez vous associer qu'à un cheval. Si vous êtes propriétaire, vous pouvez vous associer à plusieurs chevals. Cepenant, un cheval n'est associé qu'à une personne."
          ),
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
              child: Text("S'associer à ${horse.name}"),
              onPressed: () {
                  Navigator.of(context).pop();
                // const snackBar = SnackBar(
                //   duration: Duration(seconds: 2),
                //   content: Text('Vous êtes bien associé à ce cheval.'),
                // );
                // ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }
}
