import 'dart:io';

import 'package:dev_test/package.dart';
import 'package:path/path.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:process_run/shell.dart';

Future main() async {
  if (dartVersion >= Version(2, 12, 0, pre: '0')) {
    // Delete build folder when testing locally
    for (var dir in ['deploy', 'tool', 'web', 'packages']) {
      try {
        await Directory(join('build', dir)).delete(recursive: true);
      } catch (_) {}
    }

    await packageRunCi('.');
  }
}
