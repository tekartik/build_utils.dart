import 'dart:io';

import 'package:dev_test/package.dart';
import 'package:tekartik_build_utils/common_import.dart';

Future main() async {
  // Delete build folder when testing locally
  for (var dir in ['deploy', 'tool', 'web', 'packages']) {
    try {
      await Directory(join('build', dir)).delete(recursive: true);
    } catch (_) {}
  }

  await ioPackageRunCi('.');
}
