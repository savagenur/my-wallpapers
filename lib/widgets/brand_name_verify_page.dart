import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:my_wallpapers/authentification/constants.dart';
import 'package:my_wallpapers/authentification/screens/Welcome/welcome_screen.dart';
import 'package:my_wallpapers/views/account_page.dart';
import 'package:my_wallpapers/views/favorites_page.dart';
import 'package:my_wallpapers/views/home.dart';

class BrandNameVerifyPage extends StatefulWidget {
  const BrandNameVerifyPage({
    Key? key,
  }) : super(key: key);

  @override
  State<BrandNameVerifyPage> createState() => _BrandNameVerifyPage();
}

class _BrandNameVerifyPage extends State<BrandNameVerifyPage> {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        children: [
          TextSpan(
              text: "My",
              style: TextStyle(
                color: kPrimaryColor,
              )),
          TextSpan(
            text: "Wallpapers",
            style: TextStyle(
              color: Color(0xff4B4453),
            ),
          ),
        ],
      ),
    );
  }
}
