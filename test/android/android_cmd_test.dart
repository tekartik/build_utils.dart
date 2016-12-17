@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/android/android_cmd.dart';

main() {
  group('firebase_cmd', () {
    test('firebaseArgs', () async {
      expect(nameApkCommand(flavor: "staging").arguments,
          ['app/build/outputs/apk/app-staging-release.apk']);
    });
  });
}
