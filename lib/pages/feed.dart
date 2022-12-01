import 'package:flutter/material.dart';
import 'package:steack_a_cheval/pages/parties_page.dart';
import 'package:steack_a_cheval/api/people_service.dart';
import 'package:steack_a_cheval/models/People.dart';
import 'package:steack_a_cheval/pages/profil.dart';

class FeedPage extends StatefulWidget {
  static const tag = "feed";

  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  PeopleService peopleService = PeopleService();


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).iconTheme.color;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Fil d'actualité"),
        leading: IconButton(
          onPressed: () {
            // Navigate to profile page
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilPage()),);
          },
          icon: const Icon(Icons.person),
        ),
        actions: [
          PopupMenuButton(
            offset: const Offset(0, 45),
            // SET THE (X,Y) POSITION
            iconSize: 30,
            icon: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.menu, // CHOOSE YOUR CUSTOM ICON
              ),
            ),
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(Icons.content_paste, color: primaryColor),
                      SizedBox(width: 12),
                      Text("Concours"),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.class_, color: primaryColor),
                      SizedBox(width: 12),
                      Text("Cours"),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(Icons.wc, color: primaryColor),
                      SizedBox(width: 12),
                      Text("Soirées"),
                    ],
                  ),
                ),
              ];
            },
            // TODO PUSH LES VUES ICI !!!
            onSelected: (value) {
              switch (value) {
                case 0:
                  // PUSH LA VUE CONCOURS

                  break;
                case 1:
                  // PUSH LA VUE COURS

                  break;
                case 2:
                  // PUSH LA VUE SOIREES
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PartiesPage()),
                  );

                  break;
              }
            },
          )
        ],
      ),
      body: Text("")
    );
  }
}
