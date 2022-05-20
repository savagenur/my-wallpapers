import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_wallpapers/authentification/screens/Welcome/welcome_screen.dart';
import 'package:my_wallpapers/utils/utils.dart';
import 'package:my_wallpapers/views/home.dart';

import '../authentification/constants.dart';
import '../widgets/widget.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }


  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const Home()
        : Scaffold(

            backgroundColor: Colors.white,
            appBar: AppBar(

              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Color(0xff4B4453),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>WelcomeScreen()));
                    },
                  );
                },
              ),
              // automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              title: BrandName(),
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Please Verify your Email!",
                        style: TextStyle(
                            fontSize: 22,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                          child:
                              Lottie.asset("assets/animated/verification.json")),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton.icon(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    kPrimaryColor),
                                minimumSize: MaterialStateProperty.all<Size>(
                                    Size.fromHeight(50))),
                            onPressed: canResendEmail ? sendVerificationEmail : null,
                            icon: Icon(Icons.email_outlined),
                            label: Text("Resend Verify Email")),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
