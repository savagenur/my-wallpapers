import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_wallpapers/authentification/constants.dart';
import 'package:my_wallpapers/pages/no_favorites.dart';
import 'package:my_wallpapers/views/home.dart';
import 'package:my_wallpapers/views/image_view.dart';

import '../pages/favorites_list.dart';
import '../widgets/wallpapers_list.dart';
import '../widgets/widget.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
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
        title: BrandName(
          favorite: true,
        ),
        elevation: 0,
      ),
      body: StreamBuilder<List<FavoriteModel>>(
        stream: readFavorites(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final favorites = snapshot.data!;

            List favoriteListUrl = favorites.map((e) => e.imgUrl).toList();

            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child:favoriteListUrl.isEmpty?
                NoFavorites()
                : Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    GridView.count(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                        children:
                            List.generate(favoriteListUrl.length, (index) {
                          dynamic e = favoriteListUrl[index];

                          return GridTile(
                              child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ImageView(
                                        favImgUrls: favoriteListUrl,
                                        favorites: favorites,
                                        imgUrl: favoriteListUrl[index],
                                      )));
                            },
                            child: Hero(
                              tag: e,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
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
                                          if (favorites
                                              .map((e) => e.imgUrl)
                                              .toList()
                                              .contains(e)) {
                                            setState(() {
                                              deleteFavoriteWallpaper(favorites[
                                                      favorites
                                                          .map((e) => e.imgUrl)
                                                          .toList()
                                                          .indexOf(e)]
                                                  .id
                                                  .toString());
                                            });
                                            ;
                                          } else if (favorites.isEmpty ||
                                              favorites.map((e) => e.imgUrl) !=
                                                  e) {
                                            setState(() {
                                              addFavoriteWallpaper(imgUrl: e)
                                                  .then((value) {});
                                            });
                                            ;
                                          }
                                        },
                                        child: favoriteListUrl.contains(e)
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
                  ],
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
}
