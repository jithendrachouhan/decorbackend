import 'package:flutter/material.dart';

class GlobalWidgets{
  static void showErrorMessage({required BuildContext context,required String message}){
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}