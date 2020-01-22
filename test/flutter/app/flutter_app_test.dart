@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:process_run/shell_run.dart';
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
      await generate(dirName: dirName, force: true);
      expect(Directory(dirName).existsSync(), isTrue);
      expect(File(join(dirName, 'pubspec.yaml')).existsSync(), isTrue);

      // again after pub get
      await Shell(workingDirectory: dirName).run('flutter packages get');
      await generate(dirName: dirName, force: true);
    });
    test('generate_sub_dir', () async {
      var dirName =
          '.dart_tool/tekartik_build_utils/test/flutter/sub_dir/tk_flutter_example_app_sub_dir';
      try {
        await Directory(dirname(dirName)).delete(recursive: true);
      } catch (_) {}
      expect(Directory(dirName).existsSync(), isFalse);
      await generate(dirName: dirName, force: true);
      expect(Directory(dirName).existsSync(), isTrue);
      expect(File(join(dirName, 'pubspec.yaml')).existsSync(), isTrue);

      // again after pub get
      await Shell(workingDirectory: dirName).run('flutter packages get');
      await generate(dirName: dirName, force: true);
    });
    test('gitGenerate', () async {
      await gitGenerate(
          appName: 'tk_git_flutter_example_app',
          dirName:
              '.dart_tool/tekartik_build_utils/test/flutter/app/tk_git_flutter_example_app',
          force: true);
    });
    test('gitGenerate sub_dir', () async {
      try {
        await Directory(
                '.dart_tool/tekartik_build_utils/test/flutter/app/sub_dir')
            .delete(recursive: true);
      } catch (_) {}
      await gitGenerate(
          appName: 'tk_git_flutter_example_app',
          dirName:
              '.dart_tool/tekartik_build_utils/test/flutter/app/sub_dir/tk_git_flutter_example_app',
          force: true);
    });
  }, skip: !isFlutterSupported);
}
