import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:steack_a_cheval/api/party_service.dart';
import 'package:steack_a_cheval/api/people_service.dart';
import '../models/Party.dart';

class PartyCard extends StatefulWidget {
  final Party party;

  const PartyCard({Key? key, required this.party}) : super(key: key);

  @override
  State<PartyCard> createState() => _PartyCardState();
}

class _PartyCardState extends State<PartyCard> {
  PeopleService peopleService = PeopleService();
  PartyService partyService = PartyService();


  List<String> listAperoImage = [
    "apero.jpeg",
    "apero2.jpeg",
    "apero3.jpeg",
    "apero4.jpeg"
  ];
  List<String> listRepasImage = [
    "repas.jpeg",
    "repas2.jpeg",
    "repas3.jpeg",
    "repas4.jpeg"
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;

    return Padding(
      padding: const EdgeInsets.only(left: 13.0, right: 13.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 13.0, bottom: 13.0),
            child: Container(
                width: size.width,
                height: size.height / 7,
                child: Image(
                  image: AssetImage(getImageFromPartyType()),
                  fit: BoxFit.cover,
                )
            ),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.party.type,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              children: [
                Text("Rendez-vous : "),
                Text(DateFormat.yMd("fr_FR").add_jm().format(
                    widget.party.eventDate))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(widget.party.ownerComment)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text("Participants : "),
                    Text(widget.party.participants.length.toString())
                  ],
                )
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: FutureBuilder(
              future: getCorrectParticipationButton(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
                if(snapshot.hasData!){
                  if(snapshot.data! == true){
                    return TextButton(onPressed: () {
                      participationFormHandling();
                    },
                        child: Text("S'inscrire !"));
                  };
                  return const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text("Vous êtes inscrits"),
                  );
                }
                return CircularProgressIndicator();

              },

            )
          ),
          Divider(thickness: 1)


        ],
      ),
    );
  }

  String getImageFromPartyType() {
    if (widget.party.type == "Apéro") {
      var random = Random().nextInt(listAperoImage.length);
      return "images/${listAperoImage[random]}";
    }
    var random = Random().nextInt(listRepasImage.length);
    return "images/${listRepasImage[random]}";
  }

  Future<bool> getCorrectParticipationButton() async {
    var userId = await peopleService.getCurrentUserId();

    if (widget.party.participants.contains(userId)) {
      return false;
    }
    return true;

    /*TextButton(onPressed: () {},
        child: Text("S'inscrire !"));
  }*/
  }

  participationFormHandling() async {
    var userId = await peopleService.getCurrentUserId();
    partyService.addParticipant(userId, widget.party.uid);
  }
}
