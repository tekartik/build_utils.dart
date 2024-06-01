@TestOn('vm')
library;

import 'dart:io';

import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/fastlane/fastlane.dart';
import 'package:tekartik_common_utils/common_utils_import.dart';

void main() {
  final isFastlaneSupported = isFastlaneSupportedSync;
  group('fastlane', () {
    group('supported', () {
      test('check', () {
        expect(fastlaneExecutableName,
            Platform.isWindows ? 'fastlane.bat' : 'fastlane');
        expect(checkFastlaneSupportedSync(), isFastlaneSupported);
      });
      test('missing', () {},
          skip: isFastlaneSupported ? false : 'Fastlane not supported');
    });
    if (isFastlaneSupported) {
      test('version', () async {
        var version = await getFastlaneVersion();
        // Update to 2.123.0 on 2020/11/08
        expect(version, greaterThanOrEqualTo(Version(2, 123, 0)));
      });
    }
  });
}
