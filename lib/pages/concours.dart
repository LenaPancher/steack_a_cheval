import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:steack_a_cheval/api/people_service.dart';
import 'package:steack_a_cheval/pages/particpantConcours.dart';
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

  // Controllers
  TextEditingController nameConcourController = TextEditingController();
  TextEditingController adresseConcoursController = TextEditingController();
  TextEditingController authorConcoursController = TextEditingController();
  TextEditingController dateConcoursController = TextEditingController();


  @override
  void initState(){
    listConcours = concourService.getConcours();
    super.initState();

    var nameConcour = nameConcourController.text;
    var adressConcour = adresseConcoursController.text;
    var authorConcour = authorConcoursController.text;
    var dateConcour = dateConcoursController.text;
  }

  @override
  void dispose(){
    super.dispose();
    nameConcourController.dispose();
    adresseConcoursController.dispose();
    authorConcoursController.dispose();
    dateConcoursController.dispose();
  }

  TextEditingController nameConcourController = TextEditingController();
  TextEditingController adresseConcoursController = TextEditingController();
  TextEditingController authorConcoursController = TextEditingController();
  TextEditingController dateConcoursController = TextEditingController();


  final _formKey = GlobalKey<FormState>();


  void _joinConcours(){
    setState(() {
      print('ajout du participant');
    });
  }

  //void updateControllers() {
  //  if (listConcours != null) {
    //  nameConcourController.text = listConcours.;
      //authorConcoursController.text = listConcours!.author;
      //dateConcoursController.text = listConcours!.date;
      //adresseConcoursController.text = listConcours!.adress;
    //}
  //}

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
                    return formAlertConcour(context);
                  }
                  );
                },
                child: const Icon(
                  Icons.add,
                  size: 26.0,
                ),
              )
          ),

        ],
      ),
      body: FutureBuilder<List<Concours>>(
        future: listConcours,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            List<Concours> concours = snapshot.data!;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: 20,
                itemBuilder: (BuildContext context, int index){
                  return cardConcour(concours: concours[index]);
                }
            );
          }else if(snapshot.hasError){
            return Text("A error occured :${snapshot.error} + ${snapshot.hasData} + ${listConcours}");

          }
          return const Center(child: CircularProgressIndicator());
        },
      )


    );
  }


  Widget cardConcour({required Concours concours}) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 200,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                            children:[
                              Text(
                                concours.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 2.0)),
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
                        ]
                    ),
                    Divider(),
                    Row(
                        children:[
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
                                concours.date,
                                style: const TextStyle(
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

  Widget formAlertConcour(BuildContext context){
    var size = MediaQuery.of(context).size;
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
}

