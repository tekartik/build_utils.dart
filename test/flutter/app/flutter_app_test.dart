@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/android/android_import.dart';
import 'package:tekartik_build_utils/flutter/app/generate.dart';

void main() {
  group('flutter_app', () {
    test('generate', () async {
      var dirName =
          '.dart_tool/tekartik_build_utils/test/flutter/app/tk_flutter_example_app';
      try {
        await Directory(dirName).delete(recursive: true);
      } catch (_) {}
      expect(Directory(dirName).existsSync(), isFalse);
      await generate(
          dirName:
              '.dart_tool/tekartik_build_utils/test/flutter/app/tk_flutter_example_app',
          force: true);
      expect(Directory(dirName).existsSync(), isTrue);
      expect(File(join(dirName, 'pubspec.yaml')).existsSync(), isTrue);
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
