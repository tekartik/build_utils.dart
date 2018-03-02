@TestOn("vm")
import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/bash/bash.dart';
import 'package:tekartik_io_utils/io_utils_import.dart';

void main() => defineTests(true);

void defineTests([bool disableOutput = true]) {
  //useVMConfiguration();
  if (Platform.isLinux || Platform.isMacOS) {
    group('bash', () {
      test('bash', () async {
        await bash("ls", verbose: true);
      });
    });
  }
}
