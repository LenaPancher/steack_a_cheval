import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

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
      var adressConcours = adresseConcoursController.text;
      var authorConcours = authorConcoursController.text;
      var dateConcours = dateConcoursController.text;

      print(nameConcour);
      print(adressConcours);
      print(authorConcours);
      print(dateConcours);

    });
  }

  final format = DateFormat("yyyy-MM-dd");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(

            onPressed: () {
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
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 40,
            ),
          )
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
                        decoration: const BoxDecoration(color: Colors.blue),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text(
                                    'Course de la motte',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(bottom: 2.0)),
                                  Text(
                                    '52 rue de coubertin',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    'En lieu et place de la Pomponnette, en plein de cœur de Montmartre, voici Bibiche. Une jolie cuisine bistronomique et un menu qui change selon le marché et les envies du Chef. Le décor offre une atmosphère vintage décalée et rock, à l\'image de l\'équipe aussi cool que professionnelle ! C\'est la seconde affaire parisienne des deux maîtres des lieux qui ont déjà fait leurs preuves à La Maison (dans le 17ème) et qui souhaitent ici, proposer un lieu plus décontracté',
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const <Widget>[
                                  Text(
                                    'Lucas Gauvain',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    '2022/11/21 - 2022/11/23',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

