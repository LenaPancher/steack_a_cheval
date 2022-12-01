import 'package:flutter/material.dart';
import 'package:steack_a_cheval/api/party_service.dart';
import 'package:steack_a_cheval/api/people_service.dart';
import 'package:steack_a_cheval/widgets/party_form_field.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../models/Party.dart';

class PartiesPage extends StatefulWidget {
  static const tag = "parties";

  const PartiesPage({Key? key}) : super(key: key);

  @override
  State<PartiesPage> createState() => _PartiesPageState();
}

class _PartiesPageState extends State<PartiesPage> {
  // Get global key
  final _formKey = GlobalKey<FormState>();

  // Get services
  final partyService = PartyService();
  final peopleService = PeopleService();

  String partyType = "Apéro";
  List<String> eventTypeList = ["Apéro", "Repas"];
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  var _setDate;
  String? _hour, _minute, second;
  String finalTime = "";
  late DateTime chosenDate;

  // Controllers
  late TextEditingController partyTypeController;
  late TextEditingController partyCommentController;
  late TextEditingController dateController;
  late TextEditingController timeController;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();

    partyTypeController = TextEditingController();
    partyTypeController.text = "Apéro";
    partyCommentController = TextEditingController();
    dateController = TextEditingController();
    timeController = TextEditingController();
  }

  @override
  void dispose() {
    partyTypeController.dispose();
    partyCommentController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Soirées"),
        actions: [
          IconButton(
              onPressed: () {
                _dialogBuilder(context);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: Column(),
    );
  }

  _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text('Créer une soirée'),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 275,
                          child: DropdownButton(
                              value: partyType,
                              items: eventTypeList
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  partyType = value!;
                                });
                              },
                              iconEnabledColor:
                                  Theme.of(context).colorScheme.primary,
                              icon: const Icon(Icons.arrow_downward)),
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6))),
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6))),
                                label: const Center(
                                  child: Text("Choisir une heure"),
                                ),
                                contentPadding: const EdgeInsets.only(top: 0.0),
                              ),
                            ),
                          ),
                        ),
                        PartyFormField(
                          spacing: 20,
                          label: "Commentaires pour les invités",
                          controller: partyCommentController,
                          maxLines: 3,
                        ),
                      ],
                    )),
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Fermer'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Ajouter'),
                onPressed: () {
                  handlePartyForm();

                },
              ),
            ],
          );
        });
      },
    );
  }

  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        partyType = selectedValue;
      });
    }
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
        chosenDate = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, selectedTime.hour, selectedTime.minute);
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
        chosenDate = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, selectedTime.hour, selectedTime.minute);

        timeController.text = DateFormat.jm("fr_FR").format(chosenDate);
      });
    }
  }

  Future<void> handlePartyForm() async {
    var userId = await peopleService.getCurrentUserId();
    Party party = Party(userId, partyCommentController.text, partyTypeController.text, chosenDate, []);
    partyService.insertParty(party);
  }
}
