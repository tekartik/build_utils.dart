@TestOn('vm')
library;

import 'dart:io';

import 'package:tekartik_build_utils/shell/shell.dart';
import 'package:test/test.dart';

void main() {
  group('shell', () {
    test('bat', () async {
      expect(
        getBashOrBatExecutableFilename('flutter'),
        equals(Platform.isWindows ? 'flutter.bat' : 'flutter'),
      );
    });
    test('cmd', () async {
      expect(
        getBashOrCmdExecutableFilename('firebase'),
        equals(Platform.isWindows ? 'firebase.cmd' : 'firebase'),
      );
    });
  });
}
