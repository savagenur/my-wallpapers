import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_wallpapers/authentification/screens/Welcome/welcome_screen.dart';
import 'package:my_wallpapers/pages/verify_email_page.dart';
import 'package:my_wallpapers/views/home.dart';
import 'package:my_wallpapers/views/splash_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong!"),
            );
          } else if (snapshot.hasData) {
            return const VerifyEmailPage();
          }
          return const WelcomeScreen();
        },
      ),
    );
  }
}
