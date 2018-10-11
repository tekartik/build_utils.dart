import 'dart:io';

@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/shell/shell.dart';

main() {
  group('shell', () {
    test('bat', () async {
      expect(getBashOrBatExecutableFilename('flutter'),
          equals(Platform.isWindows ? 'flutter.bat' : 'flutter'));
    });
    test('cmd', () async {
      expect(getBashOrCmdExecutableFilename('firebase'),
          equals(Platform.isWindows ? 'firebase.cmd' : 'flutter'));
    });
  });
}
