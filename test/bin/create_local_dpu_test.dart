@TestOn('vm')
library;

import 'dart:io';

import 'package:path/path.dart';
import 'package:process_run/shell.dart';
import 'package:tekartik_build_utils/bin/dpu/create_local_dpu.dart';
import 'package:test/test.dart';

void main() {
  group('create_local_dpu', () {
    late Directory dir;
    setUp(() async {
      dir = await Directory.systemTemp.createTemp('create_local_dpu');
    });
    tearDown(() async {
      await dir.delete(recursive: true);
    });

    test('scripts written in each package, compiling', () async {
      var packages = <String>[];
      for (var name in ['pkg_a', 'pkg_b']) {
        var path = join(dir.path, name);
        await Directory(path).create();
        await File(
          join(path, 'pubspec.yaml'),
        ).writeAsString('name: $name\nenvironment:\n  sdk: ^3.12.0\n');
        packages.add(path);
      }
      await CreateLocalDpuCommand().parseAndRun(packages);
      for (var path in packages) {
        for (var script in ['version_info.dart', 'build_menu.dart']) {
          var file = File(join(path, '.local', script));
          expect(file.existsSync(), isTrue, reason: file.path);
          // Compiled with the package config of this package (process_run).
          var result = await runExecutableArguments('dart', [
            'compile',
            'kernel',
            '--packages=${join('.dart_tool', 'package_config.json')}',
            '-o',
            join(dir.path, 'out.dill'),
            file.path,
          ], verbose: false);
          expect(result.exitCode, 0, reason: '${result.stdout}');
        }
      }
    }, timeout: const Timeout(Duration(minutes: 2)));

    test('not a dart package', () async {
      expect(
        () => CreateLocalDpuCommand().parseAndRun([dir.path]),
        throwsStateError,
      );
    });
  });
}
