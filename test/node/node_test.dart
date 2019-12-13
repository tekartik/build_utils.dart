@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/grind/grind_app.dart';

void main() {
  final _isNodeSupported = isNodeSupported;
  group('node', () {
    group('supported', () {
      test('check', () async {
        int exitCode;

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
      test('missing', () {},
          skip: _isNodeSupported ? false : 'Node not supported');
    });

    String _lazyVersion(String version) {
      version = version.trim();
      if (version.startsWith('v')) {
        return version.substring(1);
      }
      return version;
    }

    if (_isNodeSupported) {
      test('version', () async {
        var result = await runCmd(NodeCmd(['--version']));
        var version = parseVersion(_lazyVersion(result.stdout as String));
        expect(version, greaterThanOrEqualTo(Version(6, 4, 0)));
      });
    }
  });
}
