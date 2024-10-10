class IosContentJsonDm {
  const IosContentJsonDm({
    required this.images,
    required this.info,
  });

  factory IosContentJsonDm.fromJson(Map<String, dynamic> json) {
    return IosContentJsonDm(
      info: Info.fromJson(json["info"]),
      images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
    );
  }

  final List<Image> images;
  final Info info;

  Map<String, dynamic> toJson() {
    return {
      'info': info.toJson(),
      'images': List<dynamic>.from(images.map((x) => x.toJson())),
    };
  }

  IosContentJsonDm copyWith({
    List<Image>? images,
    Info? info,
  }) =>
      IosContentJsonDm(
        images: images ?? this.images,
        info: info ?? this.info,
      );
}

class Image {
  const Image({
    required this.idiom,
    required this.filename,
    required this.scale,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      idiom: json['idiom'],
      filename: json['filename'],
      scale: json['scale'],
    );
  }

  final String idiom;
  final String filename;
  final String scale;

  Map<String, dynamic> toJson() {
    return {
      'idiom': idiom,
      'filename': filename,
      'scale': scale,
    };
  }

  Image copyWith({
    String? idiom,
    String? filename,
    String? scale,
  }) =>
      Image(
        idiom: idiom ?? this.idiom,
        filename: filename ?? this.filename,
        scale: scale ?? this.scale,
      );
}

class Info {
  const Info({
    required this.version,
    required this.author,
  });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      version: json['version'],
      author: json['author'],
    );
  }

  final int version;
  final String author;

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'author': author,
    };
  }

  Info copyWith({
    int? version,
    String? author,
  }) =>
      Info(
        version: version ?? this.version,
        author: author ?? this.author,
      );
}
