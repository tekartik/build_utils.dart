@TestOn('vm')
library;

import 'package:tekartik_build_utils/grind/grind_app.dart';
import 'package:test/test.dart';

void main() {
  group('grind_cmd', () {
    test('grind', () async {
      await runCmd(grindCmd(), verbose: false);
    });
  });
}
