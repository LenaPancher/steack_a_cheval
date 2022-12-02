import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:steack_a_cheval/api/exceptions.dart';
import 'package:steack_a_cheval/pages/feed.dart';
import 'package:steack_a_cheval/pages/forgot_password.dart';
import 'package:steack_a_cheval/pages/sign_up.dart';

import '../api/people_service.dart';

class LoginPage extends StatefulWidget {
  static const tag = "login";
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  PeopleService peopleService = PeopleService();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorText = "";

  @override
  void initState() {
    emailController.text = "";
    passwordController.text = "";
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connexion"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/logo.png"),
                    fit: BoxFit.fitWidth,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
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
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      obscureText: obscureText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ce champ est obligatoire';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Mot de passe",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          icon: (obscureText)
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Text.rich(TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                          fontSize: 12,
                        ),
                        //make link blue and underline
                        text: "Mot de passe oublié ?",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),);
                          },
                      )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40, bottom: 20),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // Check authentification
                                await signIn();
                              }
                            },
                            child: const Text("Se connecter"),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                            children: [
                              const TextSpan(text: "Pas encore de compte ? ",),
                              TextSpan(
                                  style: const TextStyle(decoration: TextDecoration.underline),
                                  //make link blue and underline
                                  text: "Inscrivez-vous !",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage()),);
                                    }
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(errorText, style: const TextStyle(color: Colors.red),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> signIn() async {
    try {
      await peopleService.signIn(emailController.text, passwordController.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FeedPage()),);
      emailController.text = "";
      passwordController.text = "";
    } on SteakException catch (e) {
      setState(() {
        errorText = e.message;
      });
    }
  }

}
