@TestOn('vm')
library;

import 'package:tekartik_build_utils/flutter/flutter.dart';
import 'package:test/test.dart';

void main() {
  group('flutter', () {
    test('install', () async {
      await installFlutter('.dart_tool/tekartik_build_utils/flutter');
    });
  });
}
