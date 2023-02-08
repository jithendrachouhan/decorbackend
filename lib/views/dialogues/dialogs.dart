import 'package:flutter/material.dart';

class Dialogs{
  static Future<void> yesNoDialog({required BuildContext context,required String body, required Function yesFunction}) async {
    await showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Alert Dialog'),
            content: Text(body),
            actions: <Widget>[
              TextButton(
                child: Text("YES"),
                onPressed: () {
                  yesFunction();
                  Navigator.of(context).pop();
                },
              ),

              TextButton(
                child: Text("NO"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }
}

