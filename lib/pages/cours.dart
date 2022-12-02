import 'package:flutter/material.dart';
import 'package:steack_a_cheval/api/cours_service.dart';
import 'package:steack_a_cheval/api/people_service.dart';
import 'package:steack_a_cheval/models/Cours.dart';
import 'package:steack_a_cheval/models/People.dart';

import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class CoursEquitation extends StatefulWidget {
  const CoursEquitation({super.key});

  @override
  State<CoursEquitation> createState() => _CoursEquitationState();
}

class _CoursEquitationState extends State<CoursEquitation> {
  PeopleService peopleService = PeopleService();
  CoursService coursService = CoursService();
  late People currentUser;
  late Future<List<Cours>> coursList;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  var _setDate;

  DateTime finalDatetime = DateTime.now();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  List<int> durationList = <int>[30, 60];
  List<String> terrainList = <String>["Carrière", "Manège"];
  List<String> disciplineList = <String>["Dressage", "Saut d’obstacle", "Endurance"];

  int durationValue = 0;
  String terrainValue = "";
  String disciplineValue = "";

  @override
  initState() {
    super.initState();
    coursList = coursService.getCours();
    peopleService.currentUser().then((result) {
      print("result: $result");
      setState(() {
        currentUser = result;
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    mailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes cours d'équitation"),
      ),
      body: Center(
        child: FutureBuilder(
            future: coursList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Cours> cours = snapshot.data!;
                return ListView.builder(
                    itemCount: cours.length,
                    itemBuilder: (context, index) {
                      final cour = cours[index];
                      return _card(cour);
                    });
              } else if (snapshot.hasError) {
                return Text("An error occured :${snapshot.error}");
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _dialogBuilder(context),
        tooltip: 'Add',
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Créer un cours'),
          content: _form(),
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
                  var cours = Cours(durationValue, finalDatetime, terrainValue, disciplineValue, currentUser.uid);
                  coursService.insertCours(cours);
                  dateController.text = "";
                  timeController.text = "";
                  Navigator.of(context).pop();
                }
                const snackBar = SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text('Création du cours bien effectué !'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _form() {
    durationValue = durationList.first;
    terrainValue = terrainList.first;
    disciplineValue = disciplineList.first;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Form(
          key: _formKey,
          child: SizedBox(
            height: 320,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: disciplineValue,
                    underline: Container(
                      height: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        disciplineValue = value!;
                      });
                    },
                    items: disciplineList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: terrainValue,
                    underline: Container(
                      height: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        terrainValue = value!;
                      });
                    },
                    items: terrainList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: durationValue,
                    underline: Container(
                      height: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onChanged: (int? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        durationValue = value!;
                      });
                    },
                    items: durationList.map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text("$value minutes"),
                      );
                    }).toList(),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: EdgeInsets.only(top: 30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6))),
                    child: TextFormField(
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: dateController,
                      onSaved: (String? val) {
                        _setDate = val;
                      },
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6))),
                        label: const Center(
                          child: Text("Choisir une date"),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _selectTime(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: EdgeInsets.only(top: 30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6))),
                    child: TextFormField(
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: timeController,
                      onSaved: (String? val) {
                        _setDate = val;
                      },
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6))),
                        label: const Center(
                          child: Text("Choisir une heure"),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _card(Cours cours) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: 80,
      width: size.width,
      child: Card(
        elevation: 1,
        color: const Color(0xFFEDEDED),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              getDisciplineImage(cours.discipline),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          cours.discipline,
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                        Text(
                          " (${cours.terrain})",
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    Text("${cours.duration.toString()} min",),
                    Text(DateFormat("dd/MM/yyyy").format(cours.trainingDate),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        locale: const Locale("fr", "FR"),
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2024));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat.yMd("fr_FR").format(selectedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;

        DateTime dateTimeChosen = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          picked.hour,
          picked.minute,
        );

        var _hour = selectedTime.hour.toString();
        var _minute = selectedTime.minute.toString();
        var finalTime = '$_hour : $_minute';

        finalDatetime = dateTimeChosen;
        timeController.text = finalTime;
      });
    }
  }

  Image getDisciplineImage(String discipline) {
    switch (discipline) {
      case "Endurance":
        return const Image(image: AssetImage("images/endurance.jpeg"));
      case "Dressage":
        return const Image(image: AssetImage("images/dressage.jpeg"));
      default:
        return const Image(image: AssetImage("images/sautobstacle.jpeg"));
    }
  }
}
