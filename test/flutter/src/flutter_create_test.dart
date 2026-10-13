@TestOn('vm')
library;

import 'package:process_run/shell.dart';
import 'package:tekartik_build_utils/src/flutter/flutter_create.dart';
import 'package:test/test.dart';

void main() {
  group('flutterCreateCommand', () {
    test('quoted', () {
      expect(
        stringToArguments(
          flutterCreateCommand(dirName: '/tmp/my app', appName: 'my_app'),
        ),
        ['flutter', 'create', '--project-name', 'my_app', '/tmp/my app'],
      );
    });
    test('options', () {
      expect(
        stringToArguments(
          flutterCreateCommand(
            dirName: 'app',
            appName: 'app',
            options: ['--platforms', 'web,linux', '--org', 'com.example'],
          ),
        ),
        [
          'flutter',
          'create',
          '--platforms',
          'web,linux',
          '--org',
          'com.example',
          '--project-name',
          'app',
          'app',
        ],
      );
    });
  });
}
