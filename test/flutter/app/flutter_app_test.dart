@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/android/android_import.dart';
import 'package:tekartik_build_utils/flutter/app/generate.dart';

void main() {
  group('flutter_app', () {
    test('generate', () async {
      await generate(
          appName: 'tk_flutter_example_app',
          dirName:
              '.dart_tool/tekartik_build_utils/test/flutter/app/tk_flutter_example_app',
          force: true);
    });
    test('gitGenerate', () async {
      await gitGenerate(
          appName: 'tk_git_flutter_example_app',
          dirName:
              '.dart_tool/tekartik_build_utils/test/flutter/app/tk_git_flutter_example_app',
          force: true);
    });
  }, skip: !isFlutterSupported);
}
