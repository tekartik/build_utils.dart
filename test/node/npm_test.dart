@TestOn('vm')
library;

import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/grind/grind_app.dart';

void main() {
  final npmSupported = isNpmSupported;
  group('npm', () {
    group('supported', () {
      test('check', () async {
        int? exitCode;

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
      test('missing', () {}, skip: npmSupported ? false : 'Npm not supported');
    });

    String lazyVersion(String version) {
      version = version.trim();
      if (version.startsWith('v')) {
        return version.substring(1);
      }
      return version;
    }

    if (npmSupported) {
      test('version', () async {
        var result = await runCmd(NpmCmd(['--version']));
        var version = parseVersion(lazyVersion(result.stdout as String));
        expect(version, greaterThanOrEqualTo(Version(3, 2, 0)));
      });
    }
  });
}
