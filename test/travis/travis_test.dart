@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/travis/travis.dart';
import 'package:tekartik_build_utils/grind/grind_app.dart';

void main() {
  final _isTravisSupported = isTravisSupportedSync;
  group('travis', () {
    group('supported', () {
      test('check', () {
        expect(
            travisExecutableName, Platform.isWindows ? 'travis.bat' : 'travis');
        expect(checkTravisSupportedSync(), _isTravisSupported);
      });
      test('missing', () {},
          skip: _isTravisSupported ? false : 'Travis not supported');
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
