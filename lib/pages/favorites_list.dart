import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future addFavoriteWallpaper({required String imgUrl}) async {
  final docFavorite = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("favorites")
      .doc();

  final favorite = FavoriteModel(
    id: docFavorite.id,
    imgUrl: imgUrl,
    created: DateTime.now(),
  );
  final json = favorite.toJson();
  await docFavorite.set(json);
}

class FavoriteModel {
  String? id;
  String? imgUrl;
  DateTime? created;
  FavoriteModel({
    this.id ,
    this.imgUrl,
    this.created,
  });

  Map<String, dynamic> toJson() =>
      {'id': id, 'imgUrl': imgUrl, 'created': created};

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created = (json['created'] as Timestamp).toDate();
    imgUrl = json['imgUrl'];
  }
}

Stream<List<FavoriteModel>> readFavorites() => FirebaseFirestore.instance
    .collection("users")
    .doc(FirebaseAuth.instance.currentUser?.uid)
    .collection("favorites")
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => FavoriteModel.fromJson(doc.data()))
        .toList());
