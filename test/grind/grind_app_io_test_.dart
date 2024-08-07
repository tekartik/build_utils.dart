@TestOn('vm')
library;

import 'package:tekartik_build_utils/grind/grind_app.dart';
import 'package:test/test.dart';

void main() {
  group('grind_app_io_', () {
    test('dev', () async {
      final result = await runCmd(grindCmd(['gsall']), verbose: true);

      expect(
          result.stdout,
          contains(
              'gsutil -m rsync -c -r build/deploy/gs/web/none gs://gs.tk4k.ovh/tmp-dev'));
    });

    test('staging', () async {
      final result =
          await runCmd(grindCmd(['staging', 'gsall']), verbose: true);

      expect(
          result.stdout,
          contains(
              'gsutil -m rsync -c -r build/deploy/gs/web/none gs://gs.tk4k.ovh/tmp-staging'));
    });

    test('prod', () async {
      final result = await runCmd(grindCmd(['prod', 'gsall']), verbose: true);

      expect(
          result.stdout,
          contains(
              'gsutil -m rsync -c -r build/deploy/gs/web/none gs://gs.tk4k.ovh/tmp'));
      expect(result.stdout, isNot(contains('gs://gs.tk4k.ovh/tmp-prod')));
    });

    test('example_browser_dev', () async {
      final result =
          await runCmd(grindCmd(['example_browser', 'gsall']), verbose: true);

      expect(
          result.stdout,
          contains(
              'build/deploy/example/gs/browser/gzip gs://gs.tk4k.ovh/tekartik_build_utils/example/browser-dev'));
    });

    test('example_browser_prod', () async {
      final result = await runCmd(
          grindCmd(['prod', 'example_browser', 'gsall']),
          verbose: true);

      expect(
          result.stdout,
          contains(
              'build/deploy/example/gs/browser/gzip gs://gs.tk4k.ovh/tekartik_build_utils/example_browser'));
    });

    test('example_browser_staging', () async {
      final result = await runCmd(
          grindCmd(['staging', 'example_browser', 'gsall']),
          verbose: true);

      expect(
          result.stdout,
          contains(
              'build/deploy/example/gs/browser/gzip gs://gs.tk4k.ovh/tekartik_build_utils-staging/sub'));
    });
  });
}
