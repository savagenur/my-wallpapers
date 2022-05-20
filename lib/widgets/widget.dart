import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:my_wallpapers/authentification/constants.dart';
import 'package:my_wallpapers/authentification/screens/Welcome/welcome_screen.dart';
import 'package:my_wallpapers/views/favorites_page.dart';
import 'package:my_wallpapers/views/home.dart';

class BrandName extends StatefulWidget {
  final bool favorite;
  const BrandName({Key? key, this.favorite=false}) : super(key: key);

  @override
  State<BrandName> createState() => _BrandNameState();
}

class _BrandNameState extends State<BrandName> {
  bool hasInternet = false;

  void checkInternet() async {
    hasInternet = await InternetConnectionChecker().hasConnection;
  }

  @override
  void initState() {
    checkInternet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const Home()));
            },
            child: Row(
              children: [
                RichText(
                    text: TextSpan(
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                        children: [
                      TextSpan(
                          text: "My",
                          style: TextStyle(
                            color: kPrimaryColor,
                          )),
                     widget.favorite?TextSpan(
                          text: "Favorites",
                          style: TextStyle(
                            color: Color(0xff4B4453),
                          )): TextSpan(
                          text: "Wallpapers",
                          style: TextStyle(
                            color: Color(0xff4B4453),
                          )),
                    ])),
               widget.favorite? Padding(
                 padding: EdgeInsets.only(top: 8),
                 child: Lottie.asset("assets/animated/favorite-location.json", height: 80),
               ):Container()
              ],
            ),
          ),
          PopupMenuButton<int>(
              icon: Lottie.asset("assets/animated/menu.json"),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      value: 0,
                      child: Row(
                        children: [
                          Lottie.asset("assets/animated/avatar.json",
                              height: 70),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "My Account",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      )),
                  PopupMenuItem(
                      value: 1,
                      onTap: () async {
                        await Phoenix.rebirth(context);

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FavoritesPage()));
                      },
                      child: Row(
                        children: [
                          Lottie.asset("assets/animated/favorite.json",
                              height: 70),

                          // Icon(Icons.favorite_outline),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Favorites",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      )),
                  PopupMenuDivider(),
                  PopupMenuItem(
                    onTap: hasInternet
                        ? () async {
                            await Phoenix.rebirth(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => WelcomeScreen()));
                            FirebaseAuth.instance.signOut();
                          }
                        : () {},
                    child: Row(
                      children: [
                        Lottie.asset("assets/animated/log-out.json",
                            height: 70),

                        // Icon(Icons.logout_outlined),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Sign out",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    value: 2,
                  ),
                ];
              }),
        ],
      ),
    );
  }
}
