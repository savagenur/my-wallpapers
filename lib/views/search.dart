import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:my_wallpapers/pages/favorites_list.dart';
import 'package:my_wallpapers/utils/utils.dart';
import 'package:my_wallpapers/widgets/prev_and_next.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../authentification/constants.dart';

import 'package:my_wallpapers/data/data.dart';
import 'package:my_wallpapers/model/wallpaper_model.dart';
import 'package:my_wallpapers/views/home.dart';
import 'package:my_wallpapers/widgets/wallpapers_list.dart';

import '../widgets/widget.dart';

class Search extends StatefulWidget {
  final List<FavoriteModel> favorites;
  final List favImgUrls;
  final String searchQuery;
  const Search(
      {Key? key,
      required this.searchQuery,
      required this.favorites,
      required this.favImgUrls})
      : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  GlobalKey<FormState> _formKey = GlobalKey();
  List<WallpaperModel> wallpapers = [];
  TextEditingController searchController = TextEditingController();
  int page = Utils.randomNumber;
  getSearchWallpapers(String query) async {
    var response = await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=$query&per_page=16&page=$page"),
        headers: {"Authorization": apiKey});

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData['photos'].forEach((element) {
      WallpaperModel wallpaperModel = WallpaperModel();
      wallpaperModel = WallpaperModel.fromJson(element);
      wallpapers.add(wallpaperModel);
    });

    setState(() {});
  }

  getMore() async {
    var response = await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=${searchController.text}&per_page=16&page=$page"),
        headers: {"Authorization": apiKey});

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData['photos'].forEach((element) {
      WallpaperModel wallpaperModel = WallpaperModel();
      wallpaperModel = WallpaperModel.fromJson(element);
      wallpapers.add(wallpaperModel);
    });

    setState(() {});
  }

  @override
  void initState() {
    getSearchWallpapers(widget.searchQuery);
    searchController.text = widget.searchQuery;
    super.initState();
  }

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  Future refreshPage() async {
    setState(() {
      wallpapers = [];
      page = Random().nextInt(20);
    });
    await getSearchWallpapers(widget.searchQuery);

    setState(() {});
    refreshController.refreshCompleted();
  }

  Future onLoad() async {
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // FocusManager.instance.primaryFocus?.unfocus();
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                  Navigator.of(context).pop();
                },
              );
            },
          ),
          // automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: BrandName(),
          elevation: 0,
        ),
        body: StreamBuilder(
          stream: readFavorites(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final favorites = snapshot.data!;

              List favoriteListUrl = favorites.map((e) => e.imgUrl).toList();
              return Container(
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
                                textInputAction: TextInputAction.search,
                                onFieldSubmitted: (value) {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  FocusScope.of(context).unfocus();

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Search(
                                            favImgUrls: favoriteListUrl,
                                            favorites: favorites,
                                            searchQuery: searchController.text,
                                          )));
                                },
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
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }
                                        FocusScope.of(context).unfocus();
                                        setState(() {
                                          wallpapers = [];
                                          getSearchWallpapers(
                                              searchController.text);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) => Search(
                                                      favImgUrls:
                                                          favoriteListUrl,
                                                      favorites: favorites,
                                                      searchQuery:
                                                          searchController
                                                              .text)));
                                        });

                                        // FocusScope.of(context).requestFocus( _focusNode);
                                      },
                                      child: Lottie.asset(
                                          "assets/animated/search2.json",
                                          height: 20),
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
                      height: 5,
                    ),
                    Expanded(
                        child: GestureDetector(
                      onPanDown: (_) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: SmartRefresher(
                        header: WaterDropMaterialHeader(
                          color: kPrimaryColor,
                        ),
                        controller: refreshController,
                        onLoading: onLoad,
                        onRefresh: refreshPage,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              WallpapersList(
                                favImgUrls: favoriteListUrl,
                                favorites: favorites,
                                wallpapers: wallpapers,
                              ),
                              // PrevAndNext(
                              //   page: page,
                              //   next: nextPage,
                              //   prev: prevPage,
                              // )
                              wallpapers.isNotEmpty
                                  ? TextButton(
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(80)),
                                      ),
                                      onPressed: seeMore,
                                      child: Lottie.asset(
                                          "assets/animated/see-more.json",
                                          height: 100))
                                  : Container()
                            ],
                          ),
                        ),
                      ),
                    ))
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
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

  Future nextPage() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      page++;
      print(page);
      getSearchWallpapers(searchController.text);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Search(
              favImgUrls: widget.favImgUrls,
              favorites: widget.favorites,
              searchQuery: searchController.text)));
    });
  }

  Future prevPage() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      wallpapers = [];
      page--;
      getSearchWallpapers(searchController.text);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Search(
              favImgUrls: widget.favImgUrls,
              favorites: widget.favorites,
              searchQuery: searchController.text)));
    });
  }
}
