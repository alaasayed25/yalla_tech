import 'package:flutter/material.dart';

class UploadCVScreen extends StatelessWidget {
  const UploadCVScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Upload CV"),
      ),

      body: Center(

        child: Container(

          padding: const EdgeInsets.all(40),

          decoration: BoxDecoration(

            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(15),

          ),

          child: const Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              Icon(Icons.upload_file,size:50),

              SizedBox(height:10),

              Text("Upload your CV"),

            ],
          ),
        ),
      ),
    );
  }
}