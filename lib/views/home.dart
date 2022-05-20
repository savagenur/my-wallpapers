import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:my_wallpapers/data/data.dart';
import 'package:my_wallpapers/model/categories_model.dart';
import 'package:my_wallpapers/widgets/prev_and_next.dart';
import '../authentification/constants.dart';

import 'package:my_wallpapers/model/wallpaper_model.dart';
import 'package:my_wallpapers/views/category.dart';
import 'package:my_wallpapers/views/image_view.dart';
import 'package:my_wallpapers/views/search.dart';
import 'package:my_wallpapers/widgets/wallpapers_list.dart';
import 'package:my_wallpapers/widgets/widget.dart';
import 'package:http/http.dart' as http;

import '../pages/favorites_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<CategoriesModel> categories = [];
  List<WallpaperModel> wallpapers = [];
  TextEditingController searchController = TextEditingController();
  bool hasInternet = false;
  bool hasIntIndictor = true;
  int page = 1;

  Future getTrendingWallpapers() async {
    if (!mounted) return;

    await checkInternet();

    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/curated?per_page=16&page=$page"),
        headers: {"Authorization": apiKey});

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData['photos'].forEach((element) {
      WallpaperModel wallpaperModel = WallpaperModel();
      wallpaperModel = WallpaperModel.fromJson(element);
      wallpapers.add(wallpaperModel);
    });

    setState(() {});
  }

  Future checkInternet() async {
    if (!mounted) return;
    hasInternet = await InternetConnectionChecker().hasConnection;

    Timer.periodic(Duration(seconds: 4), (timer) {
      if (!mounted) return;
      setState(() {
        if (hasInternet) {
          hasIntIndictor = true;
        } else if (!hasInternet) {
          hasIntIndictor = false;
        }
      });

      timer.cancel();
    });
  }

  @override
  void initState() {
    // checkInternet();
    getTrendingWallpapers();
    categories = getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: BrandName(),
        actions: [],
        elevation: 0,
      ),
      body: StreamBuilder<List<FavoriteModel>>(
        stream: readFavorites(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final favorites = snapshot.data!;

            List favoriteListUrl = favorites.map((e) => e.imgUrl).toList();

            return Container(
              // margin: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Form(
                      key: _formKey,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: kPrimaryLightColor),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                onFieldSubmitted: (_) {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  FocusScope.of(context).unfocus();

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Search(
                                            searchQuery: searchController.text,
                                          )));
                                },
                                textInputAction: TextInputAction.search,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "This field may not be empty!";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: searchController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      left: 20, bottom: 10, top: 15),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: kPrimaryColor),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  border: InputBorder.none,
                                  hintText: "Search wallpaper",
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: InkWell(
                                        onTap: () async {
                                          if (!_formKey.currentState!
                                              .validate()) {
                                            return;
                                          }
                                          FocusScope.of(context).unfocus();

                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) => Search(
                                                        searchQuery:
                                                            searchController
                                                                .text,
                                                      )));
                                        },
                                        child: Lottie.asset(
                                            "assets/animated/search2.json",
                                            height: 20)
                                        //  Icon(
                                        //   Icons.search,
                                        //   color: kPrimaryColor,
                                        //   size: 28,
                                        // ),
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    !hasInternet
                        ? Center(
                            child: hasIntIndictor
                                ? CircularProgressIndicator()
                                : null,
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListView.builder(
                                itemCount: categories.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: ((context, index) {
                                  return CategoriesTile(
                                    imgUrl: categories[index].imgUrl!,
                                    categoriesName:
                                        categories[index].categoriesName!,
                                  );
                                })),
                          ),
                    SizedBox(
                      height: 16,
                    ),
                    WallpapersList(
                      favorites: favorites,
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
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future seeMore() async {
    setState(() {
      page++;
    });
    await getTrendingWallpapers();
  }
}

class CategoriesTile extends StatelessWidget {
  final String imgUrl;
  final String categoriesName;
  const CategoriesTile(
      {Key? key, required this.imgUrl, required this.categoriesName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Category(categoryName: categoriesName)));
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(imgUrl)),
            Text(
              categoriesName,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
