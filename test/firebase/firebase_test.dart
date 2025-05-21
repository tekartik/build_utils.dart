@TestOn('vm')
library;

import 'package:tekartik_build_utils/firebase/firebase.dart';
import 'package:tekartik_build_utils/grind/grind_app.dart';
import 'package:test/test.dart';

void main() {
  final isFirebaseSupported = isFirebaseSupportedSync;
  group('firebase', () {
    group('supported', () {
      test('check', () {
        expect(
          firebaseExecutableName,
          Platform.isWindows ? 'firebase.cmd' : 'firebase',
        );
        expect(checkFirebaseSupportedSync(), isFirebaseSupported);
      });
      test(
        'missing',
        () {},
        skip: isFirebaseSupported ? false : 'Firebase not supported',
      );
    });
    test('firebaseArgs', () async {
      expect(firebaseArgs(deploy: true), ['deploy']);
      expect(firebaseArgs(deploy: true, onlyHosting: true), [
        'deploy',
        '--only',
        'hosting',
      ]);
      expect(
        firebaseArgs(deploy: true, onlyFunctions: true, onlyHosting: true),
        ['deploy', '--only', 'functions,hosting'],
      );
    });
    if (isFirebaseSupported) {
      test('version', () async {
        var result = await runCmd(FirebaseCmd(['--version']));
        var version = Version.parse((result.stdout as String).trim());
        expect(version, greaterThanOrEqualTo(Version(5, 0, 1)));
      });
    }
  });
}
