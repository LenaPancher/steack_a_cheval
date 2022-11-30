import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  static const tag = "feed";
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fil d'actualité"),
      ),
      drawer: Drawer(
        child: Column(
          children: const [
            Text("Cours"),
            Text("Soirées"),
          ],
        ),
      ),
      body: Column(

      ),

    );
  }
}
