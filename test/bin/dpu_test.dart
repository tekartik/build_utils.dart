@TestOn('vm')
library tekartik_build_utils.test.bin.dpu_test;

import 'package:process_run/shell.dart';
import 'package:tekartik_build_utils/bin/dart_project_util.dart' as dpu;
import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:test/test.dart';

var shell = Shell(
    environment: ShellEnvironment()..aliases['dpu'] = 'dart run bin/dpu.dart');

void main() {
  group('dpu', () {
    test('version', () async {
      var text = (await shell.run('dpu --version')).outText;
      expect(Version.parse(text.trim()), dpu.dpuBinVersion);
    });
  });
}
