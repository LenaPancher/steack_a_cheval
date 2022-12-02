import 'package:flutter/material.dart';
import 'package:steack_a_cheval/api/people_service.dart';
import 'package:steack_a_cheval/models/People.dart';

class ParticipantConcoursPage extends StatefulWidget {
  static const tag = "participantConcours";

  final List<dynamic> listParticipant;

  const ParticipantConcoursPage({Key? key, required this.listParticipant})
      : super(key: key);

  @override
  State<ParticipantConcoursPage> createState() => _ParticipantConcoursPage();
}

class _ParticipantConcoursPage extends State<ParticipantConcoursPage> {
  // late Future<List<People>> peopleList;
  PeopleService peopleService = PeopleService();

  @override
  void initState() {
    //peopleList = peopleService.getAllParticipant();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Participants"),
      ),
      body: FutureBuilder(
        future: peopleService.getAllParticipant(widget.listParticipant),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<People> peoples = snapshot.data!;
            print("PEOPLE  = $peoples");
            if(peoples.isEmpty){
              return Center(child: Text("Pas encore de participants."));
            }
            return ListView.builder(
                shrinkWrap: true,
                itemCount: peoples.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.people, color: Theme.of(context).colorScheme.primary,),
                      title: Text(peoples[index].pseudo),
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Text("An error occured :${snapshot.error}");
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
