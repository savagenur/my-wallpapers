import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:my_wallpapers/authentification/constants.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sorry, we couldn't find\n your request!",
              style: TextStyle(
                fontSize: 22,
                color: kPrimaryColor,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
            Container(child: Lottie.asset("assets/animated/error-404.json"))
          ],
        ),
      ),
    );
  }
}
