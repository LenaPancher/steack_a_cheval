import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:steack_a_cheval/pages/feed.dart';
import 'package:steack_a_cheval/pages/login.dart';
import 'package:steack_a_cheval/pages/partiesPage.dart';
import 'package:steack_a_cheval/pages/sign_up.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Flutter Demo',
      routes: {
        LoginPage.tag:(context) => const LoginPage(),
        SignUpPage.tag: (context) => const SignUpPage(),
        FeedPage.tag: (context) => const FeedPage(),
        PartiesPage.tag: (context) => const PartiesPage(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFFA73322),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFA73322)
        )
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr')
      ],
      home: const LoginPage(),
    );
  }
}
