@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:process_run/shell.dart';
import 'package:pub_semver/pub_semver.dart';

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
        var result = await run('travis --version');
        var version = Version.parse(result.outText.trim());
        // Reinstall on 2020/11/08
        expect(version, greaterThanOrEqualTo(Version(1, 10, 0)));
      });
    }
  });
}
