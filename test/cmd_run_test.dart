@TestOn('vm')
library;

import 'package:tekartik_build_utils/cmd_run.dart';
import 'package:tekartik_build_utils/firebase/firebase.dart';
import 'package:test/test.dart';

void main() {
  final isFirebaseSupported = isFirebaseSupportedSync;
  group('runCmd', () {
    group('not_supported', () {
      test('check', () async {
        try {
          await runCmd(FirebaseCmd(['--version']));
        } catch (_) {}
      }, skip: isFirebaseSupported);
    });
  });
}
