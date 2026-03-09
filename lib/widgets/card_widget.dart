import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {

  final String title;
  final VoidCallback onTap;

  const CardWidget({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onTap,

      child: Card(

        elevation: 3,

        child: Padding(

          padding: const EdgeInsets.all(20),

          child: Text(
            title,
            style: const TextStyle(fontSize: 18),
          ),

        ),
      ),
    );
  }
}