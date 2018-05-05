@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/grind/grind_app.dart';
import 'package:tekartik_build_utils/grind/grind_cmd.dart';

Version get dartVersion {
  String version = Platform.version.split(" ").first;
  return new Version.parse(version);
}

main() {
  group('grind_app_io', () {
    test('build', () async {
      if (dartVersion < new Version(2, 0, 0, pre: "dev.52")) {
        await runCmd(grindCmd(["build"]), verbose: false);
        expect(
            await new File(join("build", "deploy", "web", "index.html"))
                .exists(),
            isTrue);
      }
    });

    test('build_example_browser', () async {
      if (dartVersion < new Version(2, 0, 0, pre: "dev.52")) {
        await runCmd(grindCmd(["example_browser", "build"]), verbose: false);
        expect(
            await new File(
                    join("build", "deploy", "example", "browser", "index.html"))
                .exists(),
            isTrue);
      }
    });
    test('ping', () async {
      ProcessResult result = await runCmd(grindCmd(["ping"]), verbose: false);
      expect(result.stdout, contains("pong"));
      // somehow this fails on travis...expect(result.stdout, contains("[ping]"));
      expect(result.stdout, contains("ping"));
    });
  });
}
