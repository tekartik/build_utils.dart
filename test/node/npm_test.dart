@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/grind/grind_app.dart';

main() {
  bool _isNpmSupported = isNpmSupported;
  group('npm', () {
    group('supported', () {
      test('check', () async {
        int exitCode;

        try {
          var result = await runCmd(NpmCmd(['--version']));
          exitCode = result.exitCode;
        } catch (e) {
          print(e);
        }
        if (isNpmSupported) {
          expect(exitCode, 0);
        } else {
          expect(exitCode, isNot(0));
        }
      });
      test('missing', () {},
          skip: _isNpmSupported ? false : 'Npm not supported');
    });

    String _lazyVersion(String version) {
      version = version.trim();
      if (version.startsWith('v')) {
        return version.substring(1);
      }
      return version;
    }

    if (_isNpmSupported) {
      test('version', () async {
        var result = await runCmd(NpmCmd(['--version']));
        var version = parseVersion(_lazyVersion(result.stdout as String));
        expect(version, greaterThanOrEqualTo(Version(3, 2, 0)));
      });
    }
  });
}
