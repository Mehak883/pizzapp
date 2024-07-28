// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pizza_app/main.dart';

class CustomSnackBar {
  static void showSnackBar(
      BuildContext context, String label, Function() onPressed, String text) {
    final snackBar = SnackBar(
      backgroundColor: Colors.white,
      content: Text(text,style: const TextStyle(color:MyApp.reddish,fontSize: 16),),
      action: SnackBarAction(
        label: label,
        onPressed: onPressed,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}