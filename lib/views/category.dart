import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:my_wallpapers/data/data.dart';
import 'package:my_wallpapers/model/wallpaper_model.dart';
import 'package:my_wallpapers/views/home.dart';

import '../widgets/wallpapers_list.dart';
import '../widgets/widget.dart';

class Category extends StatefulWidget {
  final String categoryName;
  const Category({Key? key, required this.categoryName}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<WallpaperModel> wallpapers = [];
  int page = 1;
  getCategoryWallpapers(String query) async {
    var response = await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=$query&per_page=16&page=$page"),
        headers: {"Authorization": apiKey});
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData['photos'].forEach((e) {
      WallpaperModel wallpaperModel = WallpaperModel();
      wallpaperModel = WallpaperModel.fromJson(e);
      wallpapers.add(wallpaperModel);

      setState(() {});
    });
  }

  @override
  void initState() {
    getCategoryWallpapers(widget.categoryName);
    super.initState();
  }

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
        title: BrandName(),
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
                wallpapers: wallpapers,
              ),
              wallpapers.isNotEmpty
                  ? TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80)),
                      ),
                      onPressed: seeMore,
                      child: Lottie.asset("assets/animated/see-more.json",
                          height: 100))
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Future seeMore() async {
    setState(() {
      page++;
    });
    await getMore();
  }

  getMore() async {
    var response = await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=${widget.categoryName}&per_page=16&page=$page"),
        headers: {"Authorization": apiKey});

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData['photos'].forEach((element) {
      WallpaperModel wallpaperModel = WallpaperModel();
      wallpaperModel = WallpaperModel.fromJson(element);
      wallpapers.add(wallpaperModel);
    });

    setState(() {});
  }
}
