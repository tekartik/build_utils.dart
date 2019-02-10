@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/flutter/flutter.dart';

void main() {
  group('flutter', () {
    group('install', () async {
      await installFlutter('.dart_tool/tekartik_build_utils/flutter');
    });
  });
}
