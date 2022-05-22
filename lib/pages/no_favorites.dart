import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:my_wallpapers/authentification/constants.dart';
import 'package:my_wallpapers/views/home.dart';

class NoFavorites extends StatefulWidget {
  const NoFavorites({Key? key}) : super(key: key);

  @override
  State<NoFavorites> createState() => _NoFavoritesState();
}

class _NoFavoritesState extends State<NoFavorites> {
  bool _isLoading = true;
  @override
  void initState() {
    Timer(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No Favorites!",
              style: TextStyle(
                  fontSize: 22,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Container(child: Lottie.asset("assets/animated/empty.json")),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child:!_isLoading? ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50)),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Home()));
                  },
                  icon: Icon(Icons.add),
                  label: Text("Click to add")):Container(),
            )
          ],
        ),
      ),
    );
  }
}
