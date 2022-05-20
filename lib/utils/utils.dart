import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_wallpapers/authentification/constants.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static showSnackBar(String? text, {bool positiveMessage=false}) {
    if (text == null) return;
    final snackBar = SnackBar(
      backgroundColor:positiveMessage?Colors.green: Color.fromARGB(255, 199, 86, 77),
        content: Text(
      text,
      style: TextStyle(color: Colors.white, ),
      
    ));
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
