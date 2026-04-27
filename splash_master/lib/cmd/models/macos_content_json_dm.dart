/*
 * Copyright (c) 2026 Simform Solutions
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

/// Data models for macOS asset catalog Contents.json (imageset/colorset)
class MacosContentJson {
  const MacosContentJson({
    required this.images,
    required this.info,
    this.colors,
  });

  factory MacosContentJson.fromJson(Map<String, dynamic> json) {
    return MacosContentJson(
      info: MacosInfo.fromJson(json["info"]),
      images: json["images"] != null
          ? List<MacosImage>.from(
              json["images"].map((x) => MacosImage.fromJson(x)))
          : [],
      colors: json["colors"] != null
          ? List<MacosColor>.from(
              json["colors"].map((x) => MacosColor.fromJson(x)))
          : null,
    );
  }

  final List<MacosImage> images;
  final MacosInfo info;
  final List<MacosColor>? colors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'info': info.toJson(),
    };
    if (images.isNotEmpty) {
      map['images'] = images.map((x) => x.toJson()).toList();
    }
    if (colors != null) {
      map['colors'] = colors!.map((x) => x.toJson()).toList();
    }
    return map;
  }
}

class MacosImage {
  const MacosImage({
    required this.idiom,
    required this.filename,
    required this.scale,
    this.appearances,
  });

  factory MacosImage.fromJson(Map<String, dynamic> json) {
    return MacosImage(
      idiom: json['idiom'],
      filename: json['filename'],
      scale: json['scale'],
      appearances: json['appearances'] != null
          ? List<Map<String, dynamic>>.from(
              (json['appearances'] as List).map(
                (e) => Map<String, dynamic>.from(e as Map),
              ),
            )
          : null,
    );
  }

  final String idiom;
  final String filename;
  final String scale;
  final List<Map<String, dynamic>>? appearances;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'idiom': idiom,
      'filename': filename,
      'scale': scale,
    };
    if (appearances != null) {
      map['appearances'] = appearances;
    }
    return map;
  }
}

class MacosColor {
  const MacosColor({
    required this.idiom,
    required this.color,
    this.appearances,
  });

  factory MacosColor.fromJson(Map<String, dynamic> json) {
    return MacosColor(
      idiom: json['idiom'],
      color: MacosColorComponents.fromJson(json['color']),
      appearances: json['appearances'] != null
          ? List<Map<String, dynamic>>.from(
              (json['appearances'] as List).map(
                (e) => Map<String, dynamic>.from(e as Map),
              ),
            )
          : null,
    );
  }

  final String idiom;
  final MacosColorComponents color;
  final List<Map<String, dynamic>>? appearances;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'idiom': idiom,
      'color': color.toJson(),
    };
    if (appearances != null) {
      map['appearances'] = appearances;
    }
    return map;
  }
}

class MacosColorComponents {
  const MacosColorComponents({
    required this.colorSpace,
    required this.red,
    required this.green,
    required this.blue,
    required this.alpha,
  });

  factory MacosColorComponents.fromJson(Map<String, dynamic> json) {
    final components = json['components'] as Map<String, dynamic>;
    return MacosColorComponents(
      colorSpace: json['color-space'],
      red: components['red'],
      green: components['green'],
      blue: components['blue'],
      alpha: components['alpha'],
    );
  }

  final String colorSpace;
  final String red;
  final String green;
  final String blue;
  final String alpha;

  Map<String, dynamic> toJson() {
    return {
      'color-space': colorSpace,
      'components': {
        'red': red,
        'green': green,
        'blue': blue,
        'alpha': alpha,
      },
    };
  }
}

class MacosInfo {
  const MacosInfo({
    required this.version,
    required this.author,
  });

  factory MacosInfo.fromJson(Map<String, dynamic> json) {
    return MacosInfo(
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
}
