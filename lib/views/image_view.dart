import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:my_wallpapers/pages/favorites_list.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;
  final List favorites;
  const ImageView({
    Key? key,
    required this.imgUrl,
    required this.favorites,
  }) : super(key: key);

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  var filePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Hero(
            tag: widget.imgUrl,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                widget.imgUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    await _save();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Container(
                            height: 20,
                            alignment: Alignment.bottomCenter,
                            child: Text("Image is downloaded"))));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.white.withOpacity(0.9)),
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(colors: [
                          Color(0xffB0A8B9).withOpacity(0.6),
                          Color(0xff4B4453).withOpacity(0.4),
                        ])),
                    child: Column(
                      children: [
                        Text(
                          "Set Wallpaper",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Text(
                          "Image will be saved in Gallery",
                          style: TextStyle(fontSize: 10, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    )),
              ],
            ),
          ),
          Positioned(
              bottom: 30,
              right: 30,
              child: IconButton(
                onPressed: () async {
                  await addToFavorites(widget.imgUrl);
                },
                icon: widget.favorites.contains(widget.imgUrl)
                    ? Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 30,
                      )
                    : Icon(
                        Icons.favorite_border,
                        color: Colors.red[400],
                        size: 30,
                      ),
              ))
        ],
      ),
    );
  }

  _save() async {
    await _askPermission();

    var response = await Dio()
        .get(widget.imgUrl, options: Options(responseType: ResponseType.bytes));
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = 'my_wallpaper_$time';
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        name: name);
    print(result);
    Navigator.pop(context);
  }

  _askPermission() async {
    var storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      await Permission.storage.request();
    }
  }

  Future addToFavorites(String element) async {
    await Phoenix.rebirth(context);
    setState(() {
      if (widget.favorites.contains(element)) {
        widget.favorites.remove(element);
      } else if (!widget.favorites.contains(element)) {
        widget.favorites.add(element);
      }
    });
    print("ImageView " + widget.favorites.length.toString());
  }
}
