import 'package:flutter/material.dart';
import 'package:steack_a_cheval/api/feed_service.dart';
import 'package:steack_a_cheval/models/Concours.dart';
import 'package:steack_a_cheval/models/Cours.dart';
import 'package:steack_a_cheval/models/Party.dart';
import 'package:steack_a_cheval/pages/concours.dart';
import 'package:steack_a_cheval/pages/particpant_concours.dart';
import 'package:steack_a_cheval/pages/parties_page.dart';
import 'package:steack_a_cheval/api/people_service.dart';
import 'package:steack_a_cheval/models/People.dart';
import 'package:steack_a_cheval/pages/profil.dart';
import 'package:steack_a_cheval/pages/cours.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:steack_a_cheval/widgets/party_list_widget.dart';

import '../widgets/party_card_widget.dart';

class FeedPage extends StatefulWidget {
  static const tag = "feed";

  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  PeopleService peopleService = PeopleService();
  FeedService feedService = FeedService();

  late Future<List<Concours>> concoursList;
  late Future<List<People>> peopleList;
  late Future<List<Cours>> coursList;
  late Future<List<Party>> partyList;

  @override
  void initState() {
    peopleList = feedService.getPeoples();
    coursList = feedService.getCours();
    concoursList = feedService.getConcours();
    partyList = feedService.getParties();
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilPage()),
            );
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
                      Text('Concours')
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ConcoursPage()));
                  break;
                case 1:
                  // PUSH LA VUE COURS
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CoursEquitation()),
                  );
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Nouveaux utilisateurs",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            FutureBuilder(
                future: peopleList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<People> peoples = snapshot.data!;
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: peoples.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 120,
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            elevation: 1,
                            color: Color(0xFFEDEDED),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            peoples[index].pseudo,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 6),
                                            child: Text(
                                              "(${peoples[index].age} ans)",
                                              style: const TextStyle(
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(peoples[index].email),
                                      Text(peoples[index].phone),
                                      Text(peoples[index].linkFFEProfil),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("erreur : ${snapshot.error}");
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Nouveaux cours",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            FutureBuilder(
                future: coursList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Cours> cours = snapshot.data!;
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cours.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _card(cours[index]);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("erreur : ${snapshot.error}");
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Nouveaux concours",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            FutureBuilder(
                future: concoursList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Concours> concours = snapshot.data!;
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: concours.length,
                      itemBuilder: (BuildContext context, int index) {
                        return cardConcours(concours: concours[index]);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("erreur : ${snapshot.error}");
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Nouvelles soirées",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            FutureBuilder(
                future: partyList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Party> parties = snapshot.data!;
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: parties.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PartyCard(party: parties[index]);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("erreur : ${snapshot.error}");
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          ],
        ),
      ),
    );
  }

  Widget _card(Cours cours) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: 90,
      width: size.width,
      child: Card(
        elevation: 1,
        color: const Color(0xFFEDEDED),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              getDisciplineImage(cours.discipline),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          cours.discipline,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " (${cours.terrain})",
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    Text(
                      "${cours.duration.toString()} min",
                    ),
                    Text(
                      DateFormat("dd/MM/yyyy").format(cours.trainingDate),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Image getDisciplineImage(String discipline) {
    switch (discipline) {
      case "Endurance":
        return const Image(image: AssetImage("images/endurance.jpeg"));
      case "Dressage":
        return const Image(image: AssetImage("images/dressage.jpeg"));
      default:
        return const Image(image: AssetImage("images/sautobstacle.jpeg"));
    }
  }
  Widget cardConcours({required Concours concours}) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 150,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/concour.jpeg"),
                        fit: BoxFit.fitHeight)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            concours.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(bottom: 2.0)),
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
                    ]),
                    const Divider(),
                    Row(children: [
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
                            DateFormat.yMd("fr_FR").format(concours.date),
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ]),
                    Expanded(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  List<dynamic> list = concours.listPeople;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ParticipantConcoursPage(
                                                  listParticipant: list)));
                                },
                                child: Text(
                                    '${concours.listPeople.length} partipants'),
                              ),
                              TextButton(
                                onPressed: () {
                                },
                                child: const Text('Participer'),
                              )
                            ]))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
