import 'package:flutter/material.dart';

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Recommendations"),
      ),

      body: ListView(

        padding: const EdgeInsets.all(20),

        children: const [

          ListTile(
            leading: Icon(Icons.lightbulb),
            title: Text("Learn Machine Learning"),
          ),

          ListTile(
            leading: Icon(Icons.lightbulb),
            title: Text("Start Python Programming"),
          ),

          ListTile(
            leading: Icon(Icons.lightbulb),
            title: Text("Explore Data Science"),
          ),

        ],
      ),
    );
  }
}