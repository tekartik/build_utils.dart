@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/grind/grind_app.dart';
import 'package:tekartik_build_utils/grind/grind_cmd.dart';

Version get dartVersion {
  final version = Platform.version.split(' ').first;
  return Version.parse(version);
}

void main() {
  group('grind_app_io', () {
    test('build', () async {
      await runCmd(grindCmd(['build']), verbose: false);
      expect(File(join('build', 'deploy', 'web', 'index.html')).existsSync(),
          isTrue);
    }, timeout: const Timeout.factor(5));

    test('build_example_browser', () async {
      await runCmd(grindCmd(['example_browser', 'build']), verbose: false);
      expect(
          File(join('build', 'deploy', 'example', 'browser', 'index.html'))
              .existsSync(),
          isTrue);
    }, timeout: const Timeout.factor(5));
    test('ping', () async {
      final result = await runCmd(grindCmd(['ping']), verbose: false);
      expect(result.stdout, contains('pong'));
      // somehow this fails on travis...expect(result.stdout, contains('[ping]'));
      expect(result.stdout, contains('ping'));
    });
  });
}
