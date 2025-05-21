@TestOn('vm')
library;

import 'package:tekartik_build_utils/grind/grind_app.dart';
import 'package:test/test.dart';

void main() {
  final nodeSupported = isNodeSupported;
  group('node', () {
    group('supported', () {
      test('check', () async {
        int? exitCode;

        try {
          var result = await runCmd(NodeCmd(['--version']));
          exitCode = result.exitCode;
        } catch (e) {
          print(e);
        }
        if (isNodeSupported) {
          expect(exitCode, 0);
        } else {
          expect(exitCode, isNot(0));
        }
      });
      test(
        'missing',
        () {},
        skip: nodeSupported ? false : 'Node not supported',
      );
    });

    String lazyVersion(String version) {
      version = version.trim();
      if (version.startsWith('v')) {
        return version.substring(1);
      }
      return version;
    }

    if (nodeSupported) {
      test('version', () async {
        var result = await runCmd(NodeCmd(['--version']));
        var version = parseVersion(lazyVersion(result.stdout as String));
        expect(version, greaterThanOrEqualTo(Version(6, 4, 0)));
      });
    }
  });
}
