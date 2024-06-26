@TestOn('vm')
library;

import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/grind/grind_app.dart';

void main() {
  group('firebase_cmd', () {
    test('firebaseArgs', () async {
      expect(firebaseArgs(deploy: true), ['deploy']);
      expect(firebaseArgs(deploy: true, onlyHosting: true),
          ['deploy', '--only', 'hosting']);
      expect(firebaseArgs(deploy: true, onlyFunctions: true, onlyHosting: true),
          ['deploy', '--only', 'functions,hosting']);
    });
  });
}
