@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/grind/grind_app.dart';
import 'package:tekartik_build_utils/travis/travis.dart';

void main() {
  final travisSupported = isTravisSupportedSync;
  group('travis', () {
    group('supported', () {
      test('check', () {
        expect(
            travisExecutableName, Platform.isWindows ? 'travis.bat' : 'travis');
        expect(checkTravisSupportedSync(), travisSupported);
      });
      test('missing', () {},
          skip: travisSupported ? false : 'Travis not supported');
    });
    if (travisSupported) {
      test('version', () async {
        var result =
            await runCmd(ProcessCmd(travisExecutableName, ['version']));
        var version = Version.parse((result.stdout as String).trim());
        expect(version, greaterThanOrEqualTo(Version(1, 8, 9)));
      });
    }
  });
}
