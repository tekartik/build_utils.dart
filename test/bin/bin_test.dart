@TestOn('vm')
library tekartik_build_utils.test.bin_test;

import 'package:path/path.dart';
import 'package:process_run/cmd_run.dart' hide runCmd;
import 'package:tekartik_build_utils/bin/dart_project_util.dart' as dpu;
import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tekartik_pub/bin/src/pubbin_utils.dart';
import 'package:test/test.dart';

ProcessCmd binCmd(String bin, List<String> arguments) {
  return DartCmd([join('bin', '$bin.dart'), ...arguments]);
}

Future<String> runOutput(ProcessCmd cmd) async {
  return (await runCmd(cmd)).stdout?.toString();
}

void main() {
  group('bin', () {
    test('dpu', () async {
      var result = await runCmd(DartCmd(['example/dpu/dpu.dart', '--version'])
        ..includeParentEnvironment = false);
      expect(result.exitCode, 0);
      expect(Version.parse((result.stdout as String).trim()), dpu.binVersion);
    });
  });
}
