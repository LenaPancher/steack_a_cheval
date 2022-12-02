import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:steack_a_cheval/api/people_service.dart';
import 'package:steack_a_cheval/models/People.dart';
import 'package:steack_a_cheval/pages/horse_dp.dart';
import 'package:steack_a_cheval/pages/horse_proprietaire.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilPage extends StatefulWidget {
  static const tag = "profil";

  const ProfilPage({Key? key}) : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilState();
}

class _ProfilState extends State<ProfilPage> {
  XFile? profilePicture;
  PeopleService peopleService = PeopleService();
  late Future<People> currentPeople;
  People? people;
  bool edit = false;
  String typeChoice = "";

  late TextEditingController pseudoController = TextEditingController();
  late TextEditingController ageController = TextEditingController();
  late TextEditingController phoneController = TextEditingController();
  late TextEditingController linkController = TextEditingController();

  @override
  void initState() {
    currentPeople = peopleService.currentUser();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        actions: [
          IconButton(
              onPressed: () {
                print("PEOPLE TYPE = ${people?.type}");
                (people?.type == "Propriétaire")
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HorseProprietairePage(currentPeople: people!)),
                      )
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HorseDpPage(currentPeople: people!)),
                      );
              },
              icon: const Icon(Icons.bedroom_baby)),
          IconButton(
              onPressed: () {
                updateControllers();
                setState(() {
                  edit = !edit;
                });
              },
              icon: const Icon(Icons.edit))
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<People>(
            future: currentPeople,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                people = snapshot.data!;
                return (edit) ? profileEdit() : myProfile();
              } else if (snapshot.hasError) {
                Text("an error occured :${snapshot.error}");
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  Widget myProfile() {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(40),
      child: SizedBox(
        height: size.height / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                profilePicture == null
                    ? CircleAvatar(
                        radius: 60,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 80,
                        ))
                    : CircleAvatar(
                        radius: 60,
                        backgroundImage: FileImage(File(profilePicture!.path)),
                      ),
              ],
            ),
            const Divider(
              thickness: 1,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      people!.pseudo,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      people!.type,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            infos(icon: Icons.cake, text: (people!.age.isEmpty) ? "Non renseigné" : people!.age),
            infos(icon: Icons.alternate_email, text: people!.email),
            infos(icon: Icons.phone, text: (people!.phone.isEmpty) ? "Non renseigné" : people!.phone),
            (people!.linkFFEProfil.isEmpty) ?
            infos(icon: Icons.link, text: "Non renseigné",)
            : Row(
              children: [
                Icon(Icons.link),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text.rich(
                    TextSpan(
                        style: const TextStyle(decoration: TextDecoration.underline),
                        //make link blue and underline
                        text: people!.linkFFEProfil,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            if (await canLaunchUrl(Uri.parse(people!.linkFFEProfil))) {
                              await launchUrl(Uri.parse(people!.linkFFEProfil));
                            } else {
                              throw "Could not launch ${people!.linkFFEProfil}";
                            }
                          }
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row infos({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(text),
        ),
      ],
    );
  }

  Widget profileEdit() {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(40),
      child: SizedBox(
        height: size.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                profilePicture == null
                    ? CircleAvatar(
                        radius: 60,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 80,
                        ))
                    : CircleAvatar(
                        radius: 60,
                        backgroundImage: FileImage(File(profilePicture!.path)),
                      ),
              ],
            ),
            const Divider(
              thickness: 1,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.7,
                      child: TextField(
                        controller: pseudoController,
                      ),
                    ),
                    choiceType(),
                  ],
                ),
              ],
            ),
            infosEdit(
                icon: Icons.cake,
                controller: ageController,
                type: TextInputType.number),
            infosEdit(
                icon: Icons.phone,
                controller: phoneController,
                type: TextInputType.number),
            infosEdit(icon: Icons.link, controller: linkController),
            Center(
                child: ElevatedButton(
                    onPressed: () async {
                      People newPeople = people!;
                      newPeople.pseudo = pseudoController.text;
                      newPeople.age = ageController.text;
                      newPeople.phone = phoneController.text;
                      newPeople.linkFFEProfil = linkController.text;
                      newPeople.type = typeChoice;
                      await peopleService.updateProfile(newPeople);
                      setState(() {
                        edit = !edit;
                      });
                    },
                    child: const Text("Enregistrer"))),
          ],
        ),
      ),
    );
  }

  Row infosEdit(
      {required IconData icon,
      required TextEditingController controller,
      TextInputType type = TextInputType.text}) {
    return Row(
      children: [
        Icon(icon),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: TextField(
              keyboardType: type,
              controller: controller,
            ),
          ),
        ),
      ],
    );
  }

  Column choiceType() {
    List<Widget> widget = [];
    List<String> type = ["Demi pensionnaire", "Propriétaire"];
    for (var i = 0; i < type.length; i++) {
      Container sizedBox = Container(
        //color: Colors.red,
        width: MediaQuery.of(context).size.width - 80,
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
          title: Text(type[i]),
          leading: Radio<String>(
            activeColor: Theme.of(context).colorScheme.primary,
            value: type[i],
            groupValue: typeChoice,
            onChanged: (newValue) {
              setState(() {
                typeChoice = newValue!;
              });
            },
          ),
        ),
      );
      widget.add(sizedBox);
    }
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: widget,
    );
  }

  void updateControllers() {
    if (people != null) {
      pseudoController.text = people!.pseudo;
      ageController.text = people!.age;
      phoneController.text = people!.phone;
      linkController.text = people!.linkFFEProfil;
      typeChoice = people!.type;
    }
  }
}
