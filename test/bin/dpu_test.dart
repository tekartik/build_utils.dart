@TestOn('vm')
library;

import 'package:process_run/shell.dart';
import 'package:tekartik_build_utils/bin/dart_project_util.dart' as dpu;
import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:test/test.dart';

var shell = Shell(
  environment: ShellEnvironment()..aliases['dpu'] = 'dart run bin/dpu.dart',
);

String _tmpParseLine(String line) {
  return line.replaceAll('Running build hooks...', '');
}

void main() {
  group('dpu', () {
    test('version', () async {
      var lines = (await shell.run('dpu --version')).outLines;
      for (var line in lines) {
        print('line: "$line"');
        var parsedLine = _tmpParseLine(line);
        print('parsedLine: "$parsedLine"');
        if (parseVersionOrNull(parsedLine) != null) {
          expect(Version.parse(parsedLine), dpu.dpuBinVersion);
          return;
        }
      }
      fail('Version line not found in: ${lines.join('\n')}');
    });
  });
}
