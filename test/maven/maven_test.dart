@TestOn('vm')
library;

import 'dart:io';

import 'package:path/path.dart' show join;
import 'package:process_run/shell.dart';
import 'package:tekartik_build_utils/maven/maven.dart';
import 'package:test/test.dart';

void main() {
  bool? isMavenSupported;

  setUp(() async {
    isMavenSupported ??= await checkMavenSupported();
  });

  test('checkMavenSupported', () async {
    expect(await checkMavenSupported(), isMavenSupported);
    //await runCmd(new MavenProject(null).cmd(mvnArgs(null, version: true)));
  });

  test('checkMavenSupported executable', () async {
    var dir = await Directory.systemTemp.createTemp('build_utils_maven');
    try {
      // Only a missing executable is unsupported, the exit code is not
      // checked.
      Future<String> script(String name) async {
        var path = join(dir.path, name);
        await File(path).writeAsString('#!/bin/sh\nexit 0\n');
        await Shell(
          verbose: false,
        ).runExecutableArguments('chmod', ['+x', path]);
        return path;
      }

      expect(await checkMavenSupported(executable: await script('ok')), isTrue);
      expect(
        await checkMavenSupported(executable: join(dir.path, 'missing')),
        isFalse,
      );
    } finally {
      await dir.delete(recursive: true);
    }
  }, skip: Platform.isWindows ? 'posix shell scripts' : null);

  test('mvnArgs', () async {
    expect(mvnArgs(null), isEmpty);
    expect(mvnArgs(null, version: true), ['--version']);
    expect(mvnArgs([]), isEmpty);
    expect(mvnArgs(['dummy']), ['dummy']);
    expect(mvnArgs(['dummy'], version: true), ['--version', 'dummy']);
  });
}
