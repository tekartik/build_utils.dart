@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/fastlane/fastlane.dart';
import 'package:tekartik_build_utils/grind/grind_app.dart';

void main() {
  bool _isFastlaneSupported = isFastlaneSupportedSync;
  group('fastlane', () {
    group('supported', () {
      test('check', () {
        expect(fastlaneExecutableName,
            Platform.isWindows ? 'fastlane.bat' : 'fastlane');
        expect(checkFastlaneSupportedSync(), _isFastlaneSupported);
      });
      test('missing', () {},
          skip: _isFastlaneSupported ? false : 'Fastlane not supported');
    });
    if (_isFastlaneSupported) {
      test('version', () async {
        var result =
            await runCmd(ProcessCmd(fastlaneExecutableName, ['--version']));
        String out = result.stdout?.toString();
        var lastLine = const LineSplitter().convert(out).last;
        var index = lastLine.indexOf('fastlane');
        var version = Version.parse(lastLine.substring(index + 8).trim());
        expect(version, greaterThanOrEqualTo(Version(2, 107, 0)));
      });
    }
  });
}
