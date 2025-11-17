@TestOn('vm')
library;

import 'package:process_run/shell.dart';
import 'package:tekartik_build_utils/bin/dart_project_util.dart' as dpu;
import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:test/test.dart';

String _tmpParseLine(String line) {
  return line.replaceAll('Running build hooks...', '');
}

var shell = Shell(
  environment: ShellEnvironment()
    ..aliases['git_log'] = 'dart run lib/bin/git_log.dart',
);

void main() {
  group('bin', () {
    test('git_log', () async {
      var text = (await shell.run('git_log --version')).outText;
      expect(Version.parse(_tmpParseLine(text).trim()), dpu.dpuBinVersion);
    });
  });
}
