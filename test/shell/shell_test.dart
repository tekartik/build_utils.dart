@TestOn('vm')
library;

import 'dart:io';

import 'package:path/path.dart' show join;
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
    test('executableInPathSync', () async {
      var dir = await Directory.systemTemp.createTemp('build_utils_shell');
      try {
        var ext = Platform.isWindows ? '.bat' : '.sh';
        var toolPath = join(dir.path, 'tool$ext');
        await File(toolPath).writeAsString('');
        expect(executableInPathSync('tool', dir.path), toolPath);
        expect(executableInPathSync('tool$ext', dir.path), toolPath);
        expect(executableInPathSync('other', dir.path), isNull);
      } finally {
        await dir.delete(recursive: true);
      }
    });
  });
}
