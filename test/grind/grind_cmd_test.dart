@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/grind/grind_app.dart';
import 'package:tekartik_build_utils/grind/grind_cmd.dart';

void main() {
  group('grind_cmd', () {
    test('grind', () async {
      await runCmd(grindCmd(), verbose: false);
    });
  });
}
