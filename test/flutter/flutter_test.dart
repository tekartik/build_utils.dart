@TestOn('vm')
library;

import 'package:tekartik_build_utils/flutter/flutter.dart';
import 'package:tekartik_platform_io/util/github_util.dart';
import 'package:test/test.dart';

final _runningOnGithub = platformIo.runningOnGithub;

void main() {
  group('flutter', () {
    group('github_util', () {
      test('info', () {
        // ignore: avoid_print
        print('running on github actions: $_runningOnGithub');
      });
    });
    test(
      'install',
      () async {
        try {
          await installFlutter('.dart_tool/tekartik_build_utils/flutter');
        } catch (e, st) {
          // ignore: avoid_print
          print('$e\n$st');
        }
      },
      skip: _runningOnGithub,
      timeout: Timeout(Duration(minutes: 10)),
    );
  });
}
