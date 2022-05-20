import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:my_wallpapers/authentification/constants.dart';
import 'package:my_wallpapers/pages/favorites_list.dart';
import 'package:my_wallpapers/pages/no_internet_page.dart';
import 'package:my_wallpapers/pages/not_found_page.dart';
import 'package:my_wallpapers/views/image_view.dart';

import '../model/wallpaper_model.dart';

class WallpapersList extends StatefulWidget {
  final List wallpapers;
  final bool searchPage;
  final List<FavoriteModel> favorites;

  const WallpapersList({
    Key? key,
    required this.wallpapers,
    this.searchPage = false,
    required this.favorites,
  }) : super(key: key);

  @override
  State<WallpapersList> createState() => _WallpapersListState();
}

class _WallpapersListState extends State<WallpapersList> {
  bool notFound = false;
  bool hasInternet = true;
  Timer? timer;

  void startTimer() async {
    Timer.periodic(Duration(seconds: 10), (timer) {
      if (!mounted) return;
      setState(() {
        if (widget.wallpapers.isEmpty) {
          notFound = true;
        } else if (widget.wallpapers.isNotEmpty) {
          notFound = false;
        }
      });

      timer.cancel();
    });
    hasInternet = await InternetConnectionChecker().hasConnection;
  }

  @override
  void initState() {
    startTimer();

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 528,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: !hasInternet
          ? NoInternetPage()
          : widget.wallpapers.isEmpty && !notFound
              ? Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 3),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : notFound
                  ? NotFoundPage()
                  : GridView.count(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      children: widget.wallpapers.map((e) {
                        return GridTile(
                            child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ImageView(
                                      favorites: widget.favorites,
                                      imgUrl: e.src!.portrait!,
                                    )));
                          },
                          child: Hero(
                            tag: e.src!.portrait!,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey[200],
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          e.src!.portrait!,
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                ),
                                Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: GestureDetector(
                                      onTap: () => addFavoriteWallpaper(
                                          imgUrl: e.src!.portrait!),
                                      child: widget.favorites[2].imgUrl ==
                                              e.src!.portrait!
                                          ? Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : Icon(
                                              Icons.favorite_border,
                                              color: Colors.red[400],
                                            ),
                                    ))
                              ],
                            ),
                          ),
                        ));
                      }).toList(),
                    ),
    );
  }

  // void addToFavorites(String element) {
  //   if (widget.favorites.contains(element)) {
  //     widget.favorites.remove(element);
  //   } else if (!widget.favorites.contains(element)) {
  //     widget.favorites.add(element);
  //   }
  //   setState(() {});
  //   print(widget.favorites.length);
  // }
}
