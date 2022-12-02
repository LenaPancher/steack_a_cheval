import 'package:flutter/material.dart';
import 'package:steack_a_cheval/api/exceptions.dart';
import 'package:steack_a_cheval/api/people_service.dart';
import 'package:steack_a_cheval/models/People.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  PeopleService peopleService = PeopleService();
  String errorText = "";

  TextEditingController emailController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    emailController.text = "";
    // passwordController.text = "";
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    // passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Mot de passe oublié"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 70),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Vous avez oublié votre mot de passe ?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text("Renseignez votre adresse mail et choississez un nouveau mot de passe.", style: TextStyle(fontSize: 17),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ce champ est obligatoire';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: "Adresse email",
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 30),
                  //   child: TextFormField(
                  //     keyboardType: TextInputType.text,
                  //     controller: passwordController,
                  //     validator: (value) {
                  //       if (value == null || value.isEmpty) {
                  //         return 'Ce champ est obligatoire';
                  //       }
                  //       return null;
                  //     },
                  //     decoration: const InputDecoration(
                  //       labelText: "Nouveau mot de passe",
                  //     ),
                  //   ),
                  // ),
                  ElevatedButton(
                    onPressed: () async {
                      await peopleService.resetPassword(email:emailController.text);
                      
                    },
                    child: const Text("Valider"),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
