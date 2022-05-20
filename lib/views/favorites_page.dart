import 'package:flutter/material.dart';
import 'package:my_wallpapers/views/home.dart';

import '../widgets/wallpapers_list.dart';
import '../widgets/widget.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List favorites = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Home()));
              },
            );
          },
        ),
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: BrandName(favorite: true,),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 16,
              ),

              WallpapersList(
                favorites: [],
                wallpapers: favorites,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
