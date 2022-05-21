import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:my_wallpapers/authentification/constants.dart';
import 'package:my_wallpapers/data/data.dart';
import 'package:my_wallpapers/model/wallpaper_model.dart';
import 'package:my_wallpapers/pages/favorites_list.dart';
import 'package:my_wallpapers/utils/utils.dart';
import 'package:my_wallpapers/views/home.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../widgets/wallpapers_list.dart';
import '../widgets/widget.dart';

class Category extends StatefulWidget {
  final GlobalKey _key = GlobalKey();
  final String categoryName;
  final List favImg;
  final List<FavoriteModel> favorites;
  Category(
      {Key? key,
      required this.categoryName,
      required this.favImg,
      required this.favorites})
      : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<WallpaperModel> wallpapers = [];
  int page = Utils.randomNumber;
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

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  Future refreshPage() async {
    setState(() {
      wallpapers = [];
      page = Random().nextInt(100);
    });
    await getCategoryWallpapers(widget.categoryName);

    setState(() {});
    refreshController.refreshCompleted();
  }

  Future onLoad() async {
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.loadComplete();
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
      body: StreamBuilder<List<FavoriteModel>>(
        stream: readFavorites(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final favorites = snapshot.data!;

            List favoriteListUrl = favorites.map((e) => e.imgUrl).toList();

            return SmartRefresher(
              header: WaterDropMaterialHeader(
                color: kPrimaryColor,
              ),
              controller: refreshController,
              onLoading: onLoad,
              onRefresh: refreshPage,
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      WallpapersList(
                        favorites: favorites,
                        favImgUrls: favoriteListUrl,
                        wallpapers: wallpapers,
                      ),
                      wallpapers.isNotEmpty
                          ? TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80)),
                              ),
                              onPressed: () {
                                seeMore;
                                setState(() {});
                              },
                              child: Lottie.asset(
                                  "assets/animated/see-more.json",
                                  height: 100))
                          : Container()
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: kPrimaryColor,
            ));
          }
        },
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
