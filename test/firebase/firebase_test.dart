@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/firebase/firebase.dart';
import 'package:tekartik_build_utils/grind/grind_app.dart';

main() {
  bool _isFirebaseSupported = isFirebaseSupportedSync;
  group('firebase', () {
    group('supported', () {
      test('check', () {
        expect(firebaseExecutableName,
            Platform.isWindows ? 'firebase.cmd' : 'firebase');
        expect(checkFirebaseSupportedSync(), _isFirebaseSupported);
      });
      test('missing', () {},
          skip: _isFirebaseSupported ? false : 'Firebase not supported');
    });
    test('firebaseArgs', () async {
      expect(firebaseArgs(deploy: true), ["deploy"]);
      expect(firebaseArgs(deploy: true, onlyHosting: true),
          ['deploy', '--only', 'hosting']);
      expect(firebaseArgs(deploy: true, onlyFunctions: true, onlyHosting: true),
          ['deploy', '--only', 'functions,hosting']);
    });
    if (_isFirebaseSupported) {
      test('version', () async {
        var result = await runCmd(FirebaseCmd(['--version']));
        var version = Version.parse((result.stdout as String).trim());
        expect(version, greaterThanOrEqualTo(Version(5, 0, 1)));
      });
    }
  });
}
