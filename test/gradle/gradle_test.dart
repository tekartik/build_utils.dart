import 'dart:io';

import 'package:test/test.dart';
import 'package:tekartik_build_utils/gradle/gradle.dart';

void main() {
  group('gradle', () {
    test('executable', () {
      if (Platform.isWindows) {
        expect(gradleShellExecutableFilename, 'gradlew.bat');
      } else {
        expect(gradleShellExecutableFilename, 'gradlew');
      }
    });
  });
}
