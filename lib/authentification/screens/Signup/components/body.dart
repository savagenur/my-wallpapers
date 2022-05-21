import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_wallpapers/authentification/components/already_have_an_account_check.dart';
import 'package:my_wallpapers/authentification/components/rounded_button.dart';
import 'package:my_wallpapers/authentification/components/rounded_input_field.dart';
import 'package:my_wallpapers/authentification/components/rounded_password_field.dart';
import 'package:my_wallpapers/authentification/constants.dart';
import 'package:my_wallpapers/authentification/screens/Login/login_screen.dart';
import 'package:my_wallpapers/authentification/screens/Signup/components/background.dart';
import 'package:my_wallpapers/authentification/screens/Signup/components/or_divider.dart';
import 'package:my_wallpapers/authentification/screens/Signup/components/social_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_wallpapers/authentification/screens/Signup/signup_screen.dart';
import 'package:my_wallpapers/main.dart';

import '../../../../utils/utils.dart';

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
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Background(
        child: Form(
      key: formKey,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.03,
            ),
            Text(
              "SIGN UP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              width: size.height * 0.35,
            ),
            SizedBox(
              height: size.height * 0.015,
            ),
            RoundedInputField(
                controller: emailController,
                hintText: "Your Email",
                onChanged: (value) {}),
            RoundedPasswordField(
                controller: passwordController, onChanged: (value) {}),
            RoundedButton(
              text: "SIGNUP",
              press: signUp,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
              login: false,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            OrDivider(),
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialIcon(
                  press: () {},
                  iconSrc: "assets/icons/facebook.svg",
                ),
                SocialIcon(
                  press: () {},
                  iconSrc: 'assets/icons/twitter.svg',
                ),
                SocialIcon(
                  press: () {},
                  iconSrc: "assets/icons/google-plus.svg",
                ),
              ],
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    ));
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
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
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(value.user!.uid)
            .set({"email": value.user!.email});
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => SignupScreen()));
      return Navigator.of(context).pop();
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
