@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/grind/grind_app.dart';

main() {
  group('grind_app_io', () {
    test('build', () async {
      await runCmd(processCmd("grind", ["build", "fsdeploy"]), verbose: false);
    });
    test('ping', () async {
      ProcessResult result =
          await runCmd(processCmd("grind", ["ping"]), verbose: false);
      expect(result.stdout, contains("pong"));
      expect(result.stdout, contains("[ping]"));
    });
  });
}
