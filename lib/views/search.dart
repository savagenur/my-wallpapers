import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:my_wallpapers/widgets/prev_and_next.dart';
import '../authentification/constants.dart';

import 'package:my_wallpapers/data/data.dart';
import 'package:my_wallpapers/model/wallpaper_model.dart';
import 'package:my_wallpapers/views/home.dart';
import 'package:my_wallpapers/widgets/wallpapers_list.dart';

import '../widgets/widget.dart';

class Search extends StatefulWidget {
  final String searchQuery;
  const Search({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  GlobalKey<FormState> _formKey = GlobalKey();
  List<WallpaperModel> wallpapers = [];
  TextEditingController searchController = TextEditingController();
  int page = 1;
  getSearchWallpapers(String query) async {
    var response = await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=$query&per_page=16&page=1"),
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
        Uri.parse("https://api.pexels.com/v1/search?query=${searchController.text}&per_page=16&page=$page"),
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
        body: SingleChildScrollView(
          child: Container(
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
                                borderSide: BorderSide(color: kPrimaryColor),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              border: InputBorder.none,
                              hintText: "Search wallpaper",
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: GestureDetector(
                                  onTap: () async {
                                    if (!_formKey.currentState!.validate()) {
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
                                                  searchQuery:
                                                      searchController.text)));
                                    });

                                    // FocusScope.of(context).requestFocus( _focusNode);
                                  },
                                  child: Lottie.asset("assets/animated/search2.json", height: 20),
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
                WallpapersList(
                  favorites: [],
                  wallpapers: wallpapers,
                ),
                // PrevAndNext(
                //   page: page,
                //   next: nextPage,
                //   prev: prevPage,
                // )
               wallpapers.isNotEmpty? TextButton(
                style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),),
                onPressed: seeMore,
                child: Lottie.asset("assets/animated/see-more.json", height: 100)):Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
Future seeMore() async{
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
        builder: (context) => Search(searchQuery: searchController.text)));
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
          builder: (context) => Search(searchQuery: searchController.text)));
    });
  }
}
