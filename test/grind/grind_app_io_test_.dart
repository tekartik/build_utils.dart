@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/grind/grind_app.dart';
import 'package:tekartik_build_utils/grind/grind_cmd.dart';

main() {
  group('grind_app_io_', () {
    test('dev', () async {
      ProcessResult result = await runCmd(grindCmd(["gsall"]), verbose: true);

      expect(
          result.stdout,
          contains(
              "gsutil -m rsync -c -r build/deploy/gs/web/none gs://gs.tk4k.ovh/tmp-dev"));
    });

    test('staging', () async {
      ProcessResult result =
          await runCmd(grindCmd(["staging", "gsall"]), verbose: true);

      expect(
          result.stdout,
          contains(
              "gsutil -m rsync -c -r build/deploy/gs/web/none gs://gs.tk4k.ovh/tmp-staging"));
    });

    test('prod', () async {
      ProcessResult result =
          await runCmd(grindCmd(["prod", "gsall"]), verbose: true);

      expect(
          result.stdout,
          contains(
              "gsutil -m rsync -c -r build/deploy/gs/web/none gs://gs.tk4k.ovh/tmp"));
      expect(result.stdout, isNot(contains("gs://gs.tk4k.ovh/tmp-prod")));
    });

    test('example_browser_dev', () async {
      ProcessResult result =
          await runCmd(grindCmd(["example_browser", "gsall"]), verbose: true);

      expect(
          result.stdout,
          contains(
              "build/deploy/example/gs/browser/gzip gs://gs.tk4k.ovh/tekartik_build_utils/example/browser-dev"));
    });

    test('example_browser_prod', () async {
      ProcessResult result = await runCmd(
          grindCmd(["prod", "example_browser", "gsall"]),
          verbose: true);

      expect(
          result.stdout,
          contains(
              "build/deploy/example/gs/browser/gzip gs://gs.tk4k.ovh/tekartik_build_utils/example_browser"));
    });
  });
}
