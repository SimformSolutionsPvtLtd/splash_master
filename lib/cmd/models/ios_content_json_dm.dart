/*
 * Copyright (c) 2024 Simform Solutions
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

/// The DM used to update the `contents.json` file in iOS with the splash image
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

/// The DM used for fields that are in `contents.json`
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
