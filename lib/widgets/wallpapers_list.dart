import 'dart:async';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
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
  final List favImgUrls;
  final bool isFavorite;
  final VoidCallback? function;

  const WallpapersList({
    Key? key,
    required this.wallpapers,
    this.searchPage = false,
    required this.favorites,
    this.isFavorite = false,
    required this.favImgUrls,
    this.function,
  }) : super(key: key);

  @override
  State<WallpapersList> createState() => _WallpapersListState();
}

class _WallpapersListState extends State<WallpapersList> {
  bool notFound = false;
  bool hasInternet = true;
  Timer? timer;

  void startTimer() async {
    Timer.periodic(Duration(seconds: 6), (timer) {
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
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                  ),
                )
              : notFound
                  ? NotFoundPage()
                  : widget.isFavorite
                      ? GridView.count(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          childAspectRatio: 0.6,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                          children:
                              List.generate(widget.favImgUrls.length, (index) {
                            dynamic e = widget.favImgUrls[index];
                            print(e);

                            return GridTile(
                                child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ImageView(
                                          favImgUrls: widget.favImgUrls,
                                          favorites: widget.favorites,
                                          imgUrl: e,
                                        )));
                              },
                              child: Hero(
                                tag: e,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.grey[200],
                                        ),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.network(
                                              e,
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 10,
                                        right: 10,
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (widget.favorites
                                                .map((e) => e.imgUrl)
                                                .toList()
                                                .contains(e)) {
                                              setState(() {
                                                deleteFavoriteWallpaper(widget
                                                    .favorites[widget.favorites
                                                        .map((e) => e.imgUrl)
                                                        .toList()
                                                        .indexOf(e)]
                                                    .id
                                                    .toString());
                                              });
                                              ;
                                            } else if (widget
                                                    .favorites.isEmpty ||
                                                widget.favorites
                                                        .map((e) => e.imgUrl) !=
                                                    e) {
                                              setState(() {
                                                addFavoriteWallpaper(imgUrl: e)
                                                    .then((value) {});
                                              });
                                              ;
                                            }
                                          },
                                          child: widget.favImgUrls.contains(e)
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
                          }))
                      : GridView.count(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          childAspectRatio: 0.6,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                          children:
                              List.generate(widget.wallpapers.length, (index) {
                            dynamic e = widget.wallpapers[index];

                            return GridTile(
                                child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ImageView(
                                          favImgUrls: widget.favImgUrls,
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.grey[200],
                                        ),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                          onTap: () async {
                                            if (widget.favorites
                                                .map((e) => e.imgUrl)
                                                .toList()
                                                .contains(e.src!.portrait!)) {
                                              setState(() {
                                                deleteFavoriteWallpaper(widget
                                                    .favorites[widget.favorites
                                                        .map((e) => e.imgUrl)
                                                        .toList()
                                                        .indexOf(
                                                            e.src!.portrait!)]
                                                    .id
                                                    .toString());
                                              });
                                              ;
                                            } else if (widget
                                                    .favorites.isEmpty ||
                                                widget.favorites
                                                        .map((e) => e.imgUrl) !=
                                                    e.src!.portrait!) {
                                              setState(() {
                                                addFavoriteWallpaper(
                                                        imgUrl:
                                                            e.src!.portrait!)
                                                    .then((value) {});
                                              });
                                              ;
                                            }
                                          },
                                          child: widget.favImgUrls
                                                  .contains(e.src!.portrait!)
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
                          })

                          //  widget.wallpapers.map((e) {
                          //   print(e.toString());
                          //   return GridTile(
                          //       child: GestureDetector(
                          //     onTap: () {
                          //       Navigator.of(context).push(MaterialPageRoute(
                          //           builder: (context) => ImageView(
                          //                 favorites: widget.favorites,
                          //                 imgUrl: e.src!.portrait!,
                          //               )));
                          //     },
                          //     child: Hero(
                          //       tag: e.src!.portrait!,
                          //       child: Stack(
                          //         children: [
                          //           Positioned.fill(
                          //             child: Container(
                          //               decoration: BoxDecoration(
                          //                 borderRadius: BorderRadius.circular(20),
                          //                 color: Colors.grey[200],
                          //               ),
                          //               child: ClipRRect(
                          //                   borderRadius: BorderRadius.circular(20),
                          //                   child: Image.network(
                          //                     e.src!.portrait!,
                          //                     fit: BoxFit.cover,
                          //                   )),
                          //             ),
                          //           ),
                          //           Positioned(
                          //               bottom: 10,
                          //               right: 10,
                          //               child: GestureDetector(
                          //                 onTap: () async {
                          //                   if (!widget.favImgUrls
                          //                       .contains(e.src!.portrait!)) {
                          //                     widget.favImgUrls
                          //                         .add(e.src!.portrait!);
                          //                     addFavoriteWallpaper(
                          //                             imgUrl: e.src!.portrait!)
                          //                         .then((value) => print(e));
                          //                   } else if (widget.favImgUrls
                          //                       .contains(e.src!.portrait!)) {
                          //                     widget.favImgUrls
                          //                         .remove(e.src!.portrait!);
                          //                     deleteFavoriteWallpaper(widget
                          //                         .favorites[
                          //                             widget.favImgUrls.indexOf(e) +
                          //                                 2]
                          //                         .id
                          //                         .toString());
                          //                   }
                          //                 },
                          //                 child: widget.favImgUrls
                          //                         .contains(e.src!.portrait!)
                          //                     ? Icon(
                          //                         Icons.favorite,
                          //                         color: Colors.red,
                          //                       )
                          //                     : Icon(
                          //                         Icons.favorite_border,
                          //                         color: Colors.red[400],
                          //                       ),
                          //               ))
                          //         ],
                          //       ),
                          //     ),
                          //   ));
                          // }).toList(),
                          ),
    );
  }

  // void addToFavorites(String element) {
  //   if (widget.favImgUrls.contains(element)) {
  //     widget.favorites.remove(element);
  //   } else if (!widget.favorites.contains(element)) {
  //     widget.favorites.add(element);
  //   }
  //   setState(() {});
  //   print(widget.favorites.length);
  // }
}
