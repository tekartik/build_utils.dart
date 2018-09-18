// Copyright (c) 2016, Alexandre Roux Tekartik. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:dev_test/test.dart';
import 'package:path/path.dart';
import 'package:tekartik_build_utils/target/app_host_target.dart';
import 'package:tekartik_build_utils/target/app_host_target_mock.dart';
import 'package:tekartik_build_utils/zip/unzip.dart';
import 'package:tekartik_build_utils/zip/zip.dart';

void main() {
  group('zip', () {
    test('zip', () async {
      var dir = join('.dart_tool', 'tekartik_build_utils', 'test', 'zip_unzip');
      try {
        await Directory(dir).delete(recursive: true);
      } catch (_) {}
      var srcDir = join(dir, 'src');
      await Directory(srcDir).create(recursive: true);
      await File(join(srcDir, 'test.txt')).writeAsString('test');
      await zip(srcDir);
      var dstDir = join(dir, 'dst');
      await unzip('$srcDir.zip', dst: dstDir);
      expect(await File(join(dstDir, 'test.txt')).readAsString(), 'test');
    });
  });
}
