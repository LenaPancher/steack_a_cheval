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
  late List<Cours> coursList;

  @override
  initState() {
    super.initState();
    peopleService.currentUser().then((result) {
      print("result: $result");
      setState(() {
        currentUser = result;
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Mes cours d'équitation"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView.builder(
            itemCount: _cardList.length,
            itemBuilder: (context, index) {
              return _cardList[index];
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _dialogBuilder(context),
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  final List<Widget> _cardList = [];

  void _addCardWidget(Cours cours) {
    setState(() {
      _cardList.add(_card(cours));
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  var _setDate;
  String? _hour, _minute, second;
  String finalTime = "";

  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    mailController.dispose();
    super.dispose();
  }

  Widget _form() {
    const List<int> durationList = <int>[30, 60];
    const List<String> terrainList = <String>["Carrière", "Manège"];
    const List<String> disciplineList = <String>[
      "Dressage",
      "Saut d’obstacle",
      "Endurance"
    ];

    int durationValue = durationList.first;
    String terrainValue = terrainList.first;
    String disciplineValue = disciplineList.first;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DropdownButton<String>(
            value: disciplineValue,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                disciplineValue = value!;
              });
            },
            items: disciplineList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          DropdownButton<String>(
            value: terrainValue,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                terrainValue = value!;
              });
            },
            items: terrainList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          DropdownButton<int>(
            value: durationValue,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
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
          InkWell(
            onTap: () {
              _selectDate(context);
            },
            child: Container(
              width: 200,
              height: 50,
              margin: EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.all(Radius.circular(6))),
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
                      borderRadius: const BorderRadius.all(Radius.circular(6))),
                  label: const Center(
                    child: Text("Choisir une date"),
                  ),
                  contentPadding: const EdgeInsets.only(top: 0.0),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _selectTime(context);
            },
            child: Container(
              width: 200,
              height: 50,
              margin: EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.all(Radius.circular(6))),
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
                      borderRadius: const BorderRadius.all(Radius.circular(6))),
                  label: const Center(
                    child: Text("Choisir une heure"),
                  ),
                  contentPadding: const EdgeInsets.only(top: 0.0),
                ),
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.only(left: 150.0, top: 40.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    var cours = Cours(60, DateTime.now(), "terrain",
                        "discipline", currentUser.uid);

                    _addCardWidget(cours);

                    coursService.insertCours(cours);

                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Submit'),
              )),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Disable'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _card(Cours cours) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(top: 5, left: 8, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.withOpacity(1.0),
      ),
      child: Center(
        child: ListTile(
          leading: const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 26,
              backgroundImage: NetworkImage(
                  "https://pbs.twimg.com/profile_images/1011738395067011072/Xf9bZrMD_400x400.jpg"),
            ),
          ),
          title: Text(
            cours.discipline,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: Colors.grey),
          ),
          subtitle: Text(
            cours.terrain,
            style: const TextStyle(
                fontWeight: FontWeight.w300, fontSize: 16, color: Colors.white),
          ),
          trailing: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                width: 50,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // Text('Bonjour',
                    //     style: TextStyle(
                    //         fontSize: 20, color: Colors.grey)),
                    SizedBox(
                      width: 1,
                    ),
                    Icon(
                      Icons.handshake,
                      textDirection: ui.TextDirection.rtl,
                      size: 20,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Participer à un cours'),
          content: _form(),
        );
      },
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
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        finalTime = _hour! + ' : ' + _minute!;
        timeController.text = finalTime;
        DateTime chosenDate =
            DateTime(2023, 01, 01, selectedTime.hour, selectedTime.minute);

        timeController.text = DateFormat.jm("fr_FR").format(chosenDate);
      });
    }
  }
}
