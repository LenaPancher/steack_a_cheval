import 'package:flutter/material.dart';

class ParticipantConcoursPage extends StatefulWidget {
  static const tag = "participantConcours";

  const ParticipantConcoursPage({Key? key}) : super(key: key);

  @override
  State<ParticipantConcoursPage> createState() => _ParticipantConcoursPage();
}

class _ParticipantConcoursPage extends State<ParticipantConcoursPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Participants"),
      ),
      body: ListView.builder(
          itemCount: 27,
          itemBuilder: (BuildContext context, int index){
            return const Card(
              child: ListTile(
                leading: FlutterLogo(),
                title: Text('One-line with both widgets'),
                trailing: Icon(Icons.verified_user),
              ),
            );
          }),
    );
  }

}