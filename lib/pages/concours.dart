import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:steack_a_cheval/api/people_service.dart';
import 'package:steack_a_cheval/models/People.dart';
import 'package:steack_a_cheval/pages/particpant_concours.dart';
import 'package:steack_a_cheval/models/Concours.dart';
import 'package:steack_a_cheval/api/concours_service.dart';

class ConcoursPage extends StatefulWidget {
  static const tag = "concours";

  const ConcoursPage({Key? key}) : super(key: key);

  @override
  State<ConcoursPage> createState() => _ConcoursPage();
}

class _ConcoursPage extends State<ConcoursPage> {
  ConcourService concourService = ConcourService();
  PeopleService peopleService = PeopleService();

  late Future<List<Concours>> listConcours;
  late Future<People> currentUser;

  // Controllers
  TextEditingController nameConcourController = TextEditingController();
  TextEditingController adresseConcoursController = TextEditingController();
  TextEditingController dateConcoursController = TextEditingController();

  @override
  void initState() {
    listConcours = concourService.getConcours();
    currentUser = peopleService.currentUser();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameConcourController.dispose();
    adresseConcoursController.dispose();
    dateConcoursController.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  void _joinConcours() {
    setState(() {
      print('ajout du participant');
    });
  }

  final format = DateFormat("yyyy-MM-dd");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Concours"),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    createConcours(context);
                  },
                  child: const Icon(
                    Icons.add,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: FutureBuilder<List<Concours>>(
          future: listConcours,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Concours> concours = snapshot.data!;
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: concours.length,
                  itemBuilder: (BuildContext context, int index) {
                    return cardConcours(concours: concours[index]);
                  });
            } else if (snapshot.hasError) {
              return Text(
                  "A error occured :${snapshot.error} + ${snapshot.hasData} + ${listConcours}");
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }

  Widget cardConcours({required Concours concours}) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 150,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/concour.jpeg"),
                        fit: BoxFit.fitHeight)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            concours.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(bottom: 2.0)),
                          Text(
                            concours.adress,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ]),
                    const Divider(),
                    Row(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            concours.author,
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            DateFormat.yMd("fr_FR").format(concours.date),
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ]),
                    Expanded(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                          TextButton(
                            onPressed: () {
                              List<dynamic> list = concours.listPeople;
                              Navigator.push(context,MaterialPageRoute(builder: (context) =>ParticipantConcoursPage(listParticipant: list)));
                            },
                            child: Text('${concours.listPeople.length} partipants'),
                          ),
                          TextButton(
                            onPressed: () {
                              _joinConcours();
                            },
                            child: const Text('Participer'),
                          )
                        ]))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createConcours(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<People>(
          future: currentUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              People people = snapshot.data!;
              return AlertDialog(
                content: formConcours(),
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
                        Concours concours = Concours(
                          name: nameConcourController.text,
                          adress: adresseConcoursController.text,
                          author: people.pseudo,
                          date: DateTime.parse(dateConcoursController.text),
                          listPeople: [],
                          userId: people.uid,
                        );
                        await concourService.insertConcours(concours);
                        Navigator.of(context).pop();
                        setState(() {});
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
            } else if (snapshot.hasError) {
              return Text("erreur : ${snapshot.error}");
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }

  Widget formConcours() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ce Champ est vide';
                      }
                      return null;
                    },
                    controller: nameConcourController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter name of concour',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ce Champ est vide';
                      }
                      return null;
                    },
                    controller: adresseConcoursController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter adress of concour',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DateTimeField(
                    format: format,
                    controller: dateConcoursController,
                    decoration: const InputDecoration(
                      labelText: "Date of concour",
                      border: UnderlineInputBorder(),
                    ),
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
