@TestOn('vm')
library;

import 'package:tekartik_build_utils/bash/bash.dart';
import 'package:tekartik_io_utils/io_utils_import.dart';
import 'package:test/test.dart';

void main() => defineTests(true);

void defineTests([bool disableOutput = true]) {
  //useVMConfiguration();
  if (Platform.isLinux || Platform.isMacOS) {
    group('bash', () {
      test('bash', () async {
        await bash('ls', verbose: true);
      });

      test('currentDirectory', () async {
        var result = await bash('pushd test ; pwd', verbose: true);
        expect(result.stdout.toString(), contains('build_utils.dart/test'));
      });
    });
  }
}
