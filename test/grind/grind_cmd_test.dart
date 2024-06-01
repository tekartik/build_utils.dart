@TestOn('vm')
library;

import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/grind/grind_app.dart';

void main() {
  group('grind_cmd', () {
    test('grind', () async {
      await runCmd(grindCmd(), verbose: false);
    });
  });
}
