class WallpaperModel {
  String? photographer;
  String? photographerUrl;
  int? photographerId;
  SrcModel? src;

  WallpaperModel({
    this.photographer,
    this.photographerUrl,
    this.photographerId,
    this.src,
  });

  factory WallpaperModel.fromJson(Map<String, dynamic> json) {
    return WallpaperModel(
      photographer: json['photographer'],
      photographerId: json['photographer_id'],
      photographerUrl: json['photographer_url'],
      src: SrcModel.fromJson(json['src']),
    );
  }
}

class SrcModel {
  String? original;
  String? small;
  String? portrait;
  SrcModel({
    this.original,
    this.small,
    this.portrait,
  });

  factory SrcModel.fromJson(Map<String, dynamic> json){
    return SrcModel(
      original: json['original'],
      small: json['small'],
      portrait: json['portrait'],

    );
  }
}
