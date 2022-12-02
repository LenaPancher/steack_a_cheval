import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:steack_a_cheval/widgets/party_card_widget.dart';


class PartyList extends StatefulWidget {
  const PartyList({Key? key}) : super(key: key);

  @override
  State<PartyList> createState() => _PartyListState();
}

class _PartyListState extends State<PartyList> {
  final Stream<QuerySnapshot> _partyStream = FirebaseFirestore.instance
      .collection('parties')
      .orderBy("createdAt")
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text("coucou")],
    );
  }
}
