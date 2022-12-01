import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:steack_a_cheval/pages/particpantConcours.dart';

class ConcoursPage extends StatefulWidget {
  static const tag = "concours";

  const ConcoursPage({Key? key}) : super(key: key);

  @override
  State<ConcoursPage> createState() => _ConcoursPage();
}


class _ConcoursPage extends State<ConcoursPage> {

  TextEditingController nameConcourController = TextEditingController();
  TextEditingController adresseConcoursController = TextEditingController();
  TextEditingController authorConcoursController = TextEditingController();
  TextEditingController dateConcoursController = TextEditingController();


  final _formKey = GlobalKey<FormState>();

  void _addUser(){
    setState(() {
      var nameConcour = nameConcourController.text;
      var adressConcour = adresseConcoursController.text;
      var authorConcour = authorConcoursController.text;
      var dateConcour = dateConcoursController.text;

      print(nameConcour);
      print(adressConcour);
      print(authorConcour);
      print(dateConcour);

    });
  }

  void _joinConcours(){
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
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                    return AlertDialog(
                      content: Stack(
                        children: <Widget>[
                          Positioned(
                            right: -20.0,
                            top: -20.0,
                            child: InkResponse(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Form(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.always,
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
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Ce Champ est vide';
                                      }
                                      return null;
                                    },
                                    controller: authorConcoursController,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      labelText: 'Enter author of concour',
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

                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _addUser();
                                      }
                                      nameConcourController.text = "";
                                      adresseConcoursController.text = "";
                                      authorConcoursController.text = "";
                                      dateConcoursController.text = "";
                                    },
                                    child: const Text('Submit')
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  );
                },
                child: Icon(
                  Icons.add,
                  size: 26.0,
                ),
              )
          ),

        ],
      ),
      body: ListView.builder(
          itemCount: 20,
          itemBuilder: (BuildContext context, int index){
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                height: 200,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("images/concour.jpeg"),
                              fit: BoxFit.fitHeight
                            )),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 2.0, 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children:[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text(
                                      'Course de la motte',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.only(bottom: 2.0)),
                                    Text(
                                      '52 rue de coubertin',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ]
                            ),
                            Divider(),
                            Row(
                              children:[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  //mainAxisAlignment: MainAxisAlignment.end,
                                  children: const <Widget>[
                                    Text(
                                      'Lucas Gauvain',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      '2022/11/21 - 2022/11/23',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ]
                            ),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children:[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(ParticipantConcoursPage.tag);
                                    },
                                    child: const Text('27 partipants'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _joinConcours();
                                    },
                                    child: const Text('Participer'),
                                  )
                                ]
                              )
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      )
    );

  }

}

