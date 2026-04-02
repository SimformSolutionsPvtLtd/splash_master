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

  /// The list of images in the `contents.json`
  final List<Image> images;
  /// The info section in the `contents.json`
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
    this.appearances,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      idiom: json['idiom'],
      filename: json['filename'],
      scale: json['scale'],
      appearances: json['appearances'] != null
          ? List<Appearance>.from(
              json['appearances'].map((x) => Appearance.fromJson(x)))
          : null,
    );
  }

  /// The device idiom, e.g. 'iphone', 'ipad'
  final String idiom;

  /// The filename of the image
  final String filename;

  /// The scale of the image, e.g. '1x', '2x', '3x'
  final String scale;

  /// The list of appearances for dark mode support
  final List<Appearance>? appearances;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'idiom': idiom,
      'filename': filename,
      'scale': scale,
    };
    if (appearances != null) {
      map['appearances'] = appearances!.map((x) => x.toJson()).toList();
    }
    return map;
  }

  Image copyWith({
    String? idiom,
    String? filename,
    String? scale,
    List<Appearance>? appearances,
  }) =>
      Image(
        idiom: idiom ?? this.idiom,
        filename: filename ?? this.filename,
        scale: scale ?? this.scale,
        appearances: appearances ?? this.appearances,
      );
}

/// The DM used for appearance entries in `contents.json` for dark mode support
class Appearance {
  const Appearance({
    /// The appearance type, typically 'luminosity' for brightness-based switching
    required this.appearance,
    /// The appearance value: 'light' for light mode, 'dark' for dark mode
    required this.value,
  });

  factory Appearance.fromJson(Map<String, dynamic> json) {
    return Appearance(
      appearance: json['appearance'],
      value: json['value'],
    );
  }

  /// The appearance type, e.g. 'luminosity'
  final String appearance;

  /// The appearance value, e.g. 'light' or 'dark'
  final String value;

  Map<String, dynamic> toJson() {
    return {
      'appearance': appearance,
      'value': value,
    };
  }

  Appearance copyWith({
    String? appearance,
    String? value,
  }) =>
      Appearance(
        appearance: appearance ?? this.appearance,
        value: value ?? this.value,
      );

  /// Helper to create a light appearance
  static Appearance light() => const Appearance(
        appearance: 'luminosity',
        value: 'light',
      );

  /// Helper to create a dark appearance
  static Appearance dark() => const Appearance(
        appearance: 'luminosity',
        value: 'dark',
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

  /// The version of the contents.json format
  final int version;

  /// The author of the contents.json file
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
