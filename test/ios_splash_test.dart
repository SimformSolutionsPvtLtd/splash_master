import 'dart:io';

import 'package:splash_master/cmd/cmd_strings.dart';
import 'package:splash_master/cmd/command_line.dart';
import 'package:splash_master/values/ios_strings.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('updateContentOfStoryboard', () {
    test(
      'anchors splash and background images from their own iOS content modes',
      () async {
        final document = await _generateStoryboard(
          splashContentMode: 'topLeft',
          backgroundContentMode: 'topRight',
          includeBackgroundImage: true,
        );

        final splashImage = _imageViewById(
          document,
          IOSStrings.defaultImageViewIdValue,
        );
        final backgroundImage = _imageViewById(
          document,
          IOSStrings.backgroundImageViewIdValue,
        );

        expect(splashImage.getAttribute('contentMode'), 'topLeft');
        expect(backgroundImage.getAttribute('contentMode'), 'topRight');

        expect(
          _constraintAttributes(document, IOSStrings.defaultImageViewIdValue),
          unorderedEquals(['top', 'leading']),
        );
        expect(
          _constraintAttributes(
              document, IOSStrings.backgroundImageViewIdValue),
          unorderedEquals(['top', 'trailing']),
        );
      },
    );

    test('uses center constraints for center content mode', () async {
      final document = await _generateStoryboard(splashContentMode: 'center');

      expect(
        _constraintAttributes(document, IOSStrings.defaultImageViewIdValue),
        unorderedEquals(['centerY', 'centerX']),
      );
    });

    test('pins all four edges for fill content modes', () async {
      final document = await _generateStoryboard(
        splashContentMode: 'scaleAspectFill',
      );

      expect(
        _constraintAttributes(document, IOSStrings.defaultImageViewIdValue),
        unorderedEquals(['leading', 'trailing', 'top', 'bottom']),
      );
    });

    test('stays idempotent across repeated storyboard updates', () async {
      final testProject =
          await _createTestProject(includeBackgroundImage: true);

      try {
        await _withCurrentDirectory(testProject.path, () async {
          await updateContentOfStoryboard(
            imagePath: 'assets/splash.png',
            iosContentMode: 'topLeft',
            backgroundImage: 'assets/background.png',
            iosBackgroundContentMode: 'bottomRight',
          );
          await updateContentOfStoryboard(
            imagePath: 'assets/splash.png',
            iosContentMode: 'topLeft',
            backgroundImage: 'assets/background.png',
            iosBackgroundContentMode: 'bottomRight',
          );
        });

        final document = XmlDocument.parse(
          await File(
            '${testProject.path}/${CmdStrings.storyboardPath}',
          ).readAsString(),
        );

        expect(
          document.findAllElements(IOSStrings.imageViewElement).length,
          2,
        );
        expect(document.findAllElements('constraint').length, 4);
        expect(
          _constraintAttributes(document, IOSStrings.defaultImageViewIdValue),
          unorderedEquals(['top', 'leading']),
        );
        expect(
          _constraintAttributes(
              document, IOSStrings.backgroundImageViewIdValue),
          unorderedEquals(['bottom', 'trailing']),
        );
      } finally {
        await testProject.delete(recursive: true);
      }
    });
  });
}

Future<XmlDocument> _generateStoryboard({
  required String splashContentMode,
  String? backgroundContentMode,
  bool includeBackgroundImage = false,
}) async {
  final testProject = await _createTestProject(
    includeBackgroundImage: includeBackgroundImage,
  );

  try {
    await _withCurrentDirectory(testProject.path, () async {
      await updateContentOfStoryboard(
        imagePath: 'assets/splash.png',
        color: '#112233',
        iosContentMode: splashContentMode,
        backgroundImage:
            includeBackgroundImage ? 'assets/background.png' : null,
        iosBackgroundContentMode: backgroundContentMode,
      );
    });

    return XmlDocument.parse(
      await File('${testProject.path}/${CmdStrings.storyboardPath}')
          .readAsString(),
    );
  } finally {
    await testProject.delete(recursive: true);
  }
}

Future<Directory> _createTestProject({
  bool includeBackgroundImage = false,
}) async {
  final root = await Directory.systemTemp.createTemp('splash_master_test_');
  await File('${root.path}/${CmdStrings.storyboardPath}')
      .create(recursive: true);
  await File('${root.path}/${CmdStrings.storyboardPath}')
      .writeAsString(_baseStoryboard);

  await File('${root.path}/assets/splash.png').create(recursive: true);
  await File('${root.path}/assets/splash.png').writeAsBytes([0, 1, 2]);

  if (includeBackgroundImage) {
    await File('${root.path}/assets/background.png').create(recursive: true);
    await File('${root.path}/assets/background.png').writeAsBytes([3, 4, 5]);
  }

  return root;
}

Future<void> _withCurrentDirectory(
  String path,
  Future<void> Function() action,
) async {
  final previousDirectory = Directory.current;
  Directory.current = path;

  try {
    await action();
  } finally {
    Directory.current = previousDirectory;
  }
}

XmlElement _imageViewById(XmlDocument document, String id) {
  return document.findAllElements(IOSStrings.imageViewElement).firstWhere(
        (element) => element.getAttribute(IOSStrings.defaultImageViewId) == id,
      );
}

List<String> _constraintAttributes(XmlDocument document, String firstItem) {
  return document
      .findAllElements('constraint')
      .where((element) => element.getAttribute('firstItem') == firstItem)
      .map((element) => element.getAttribute('firstAttribute'))
      .whereType<String>()
      .toList();
}

const _baseStoryboard = '''<?xml version="1.0" encoding="UTF-8"?>
<document type="com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB" version="3.0" toolsVersion="23504" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" launchScreen="YES" colorMatched="YES" initialViewController="01J-lp-oVM">
    <scenes>
        <scene sceneID="EHf-IW-A2E">
            <objects>
                <viewController id="01J-lp-oVM" sceneMemberID="viewController">
                    <view key="view" contentMode="scaleToFill" id="${IOSStrings.defaultViewId}">
                        <rect key="frame" x="0.0" y="0.0" width="393" height="852"/>
                    </view>
                </viewController>
            </objects>
        </scene>
    </scenes>
</document>
''';
