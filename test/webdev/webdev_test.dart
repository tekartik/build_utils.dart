@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/grind/grind_app.dart';
import 'package:tekartik_build_utils/travis/travis.dart';
import 'package:tekartik_build_utils/webdev/webdev.dart';

void main() {
  final _isTravisSupported = isTravisSupportedSync;
  group('webdev', () {
    group('activate', () {
      test('check', () async {
        await webdevActivate();
      });
    });
    if (_isTravisSupported) {
      test('version', () async {
        var result =
            await runCmd(ProcessCmd(travisExecutableName, ['version']));
        var version = Version.parse((result.stdout as String).trim());
        expect(version, greaterThanOrEqualTo(Version(1, 8, 9)));
      });
    }
  });
}
