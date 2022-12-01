import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUser {

  CollectionReference concours_db = FirebaseFirestore.instance.collection('concours');

  createConcours(String name, String author, DateTime date, List<String> listpeople) async{
    try{
      await concours_db.add({
        name: name,
        author: author,
        date: date,
        listpeople:listpeople
      });
      print("new concours");

    } catch(e){
      print(e);
    }
  }

  listParticipants() async{
      return FutureBuilder<DocumentSnapshot>(
        future: users.doc(documentId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            return Text("Full Name: ${data['full_name']} ${data['last_name']}");
          }

          return Text("loading");
        },
      );
    }

  }


