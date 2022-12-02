import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../models/Party.dart';

class PartyCard extends StatefulWidget {
  final Party party;

  const PartyCard({Key? key, required this.party}) : super(key: key);

  @override
  State<PartyCard> createState() => _PartyCardState();
}

class _PartyCardState extends State<PartyCard> {
  List<String> listAperoImage = ["apero.jpeg", "apero2.jpeg", "apero3.jpeg", "apero4.jpeg"];
  List<String> listRepasImage = ["repas.jpeg", "repas2.jpeg", "repas3.jpeg", "repas4.jpeg"];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

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
                Text(DateFormat.yMd("fr_FR").add_jm().format(widget.party.eventDate))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(widget.party.ownerComment)),
          ),
          SizedBox(height: 20),
          Divider(thickness: 1,)


        ],
      ),
    );
  }

  String getImageFromPartyType(){
    if(widget.party.type == "Apéro"){
      var random = Random().nextInt(listAperoImage.length);
      print("images/${listAperoImage[random]}");
      return "images/${listAperoImage[random]}";
    }
    var random = Random().nextInt(listRepasImage.length);
    return "images/${listRepasImage[random]}";
  }
}
