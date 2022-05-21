import 'dart:ffi';

import 'package:lottie/lottie.dart';
import 'package:my_wallpapers/authentification/components/rounded_button.dart';
import 'package:my_wallpapers/authentification/components/rounded_input_field.dart';
import 'package:my_wallpapers/authentification/components/text_field_container.dart';
import 'package:my_wallpapers/authentification/constants.dart';
import 'package:my_wallpapers/authentification/screens/Login/components/background.dart';
import 'package:my_wallpapers/authentification/screens/Login/login_screen.dart';
import 'package:my_wallpapers/authentification/screens/Signup/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_wallpapers/main.dart';
import 'package:my_wallpapers/utils/utils.dart';

import '../../../components/already_have_an_account_check.dart';
import '../../../components/rounded_password_field.dart';
import '../../Signup/signup_screen.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
        child: SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'RESET YOUR PASSWORD',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Lottie.asset(
              "assets/animated/password.json",
              height: size.height * 0.45,
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            RoundedInputField(
              controller: emailController,
              hintText: "Your Email",
              onChanged: (value) {},
            ),
            RoundedButton(text: "RESET PASSWORD", press: resetPassword),
            SizedBox(
              height: size.height * 0.03,
            ),
            AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return LoginScreen();
                  }));
                }),
            SizedBox(
              height: size.height * 0.03,
            ),
          ],
        ),
      ),
    ));
  }

  Future resetPassword() async {
    bool isValid;
    isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(
              color: kPrimaryColor,
            ),
          );
        });
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Utils.showSnackBar("Password Reset Email Sent", positiveMessage: true);
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(
        e.message,
      );
    }
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }
}
