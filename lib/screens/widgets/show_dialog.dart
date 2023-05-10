
import 'package:flutter/material.dart';

class ShowMessage{
  BuildContext context;
  String title;
  String message;
  ShowMessage(this.context,this.title,this.message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          // To display the title it is optional
          content: Text(message,style: const TextStyle(
              fontWeight: FontWeight.bold,color: Colors.black
          ),),
          // Message which will be pop up on the screen
          // Action widget which will provide the user to acknowledge the choice
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: Colors.deepOrange,
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                //Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

}