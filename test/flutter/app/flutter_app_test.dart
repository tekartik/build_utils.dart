import 'package:process_run/shell_run.dart';
import 'package:tekartik_build_utils/android/android_import.dart';
import 'package:tekartik_build_utils/flutter/app/generate.dart';
import 'package:tekartik_build_utils/flutter/flutter.dart';
@TestOn('vm')
import 'package:test/test.dart';

// 30s not enough on windows
const generateTimeout = Timeout(Duration(minutes: 3));

void main() {
  group('flutter_app', () {
    test('fs_generate', () async {
      var dirName =
          '.dart_tool/tekartik_build_utils/test/flutter/app/tk_flutter_gen_app_template';
      var src = 'test/data/app_template';
      await fsGenerate(dir: dirName, src: src);
      expect(await File(join(dirName, 'README.md')).readAsString(),
          await File(join(src, 'README.md')).readAsString());
      var shell = Shell(workingDirectory: dirName);
      await shell.run('dart bin/main.dart');
      var context = await flutterContext;
      if (context.supportsWeb) {
        await shell.run('flutter build web');
      }
      // generate again
      await fsGenerate(dir: dirName, src: src);
      expect(File(join(dirName, 'pubspec.yaml')).existsSync(), isTrue);
    }, timeout: generateTimeout);
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

      var context = await flutterContext;
      if (context.supportsWeb) {
        await Shell(workingDirectory: dirName).run('flutter build web');
      }
    }, timeout: generateTimeout);
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
    }, timeout: generateTimeout);
    test('gitGenerate', () async {
      await gitGenerate(
          appName: 'tk_git_flutter_example_app',
          dirName:
              '.dart_tool/tekartik_build_utils/test/flutter/app/tk_git_flutter_example_app',
          force: true);
    }, timeout: generateTimeout);
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
    }, timeout: generateTimeout);
  }, skip: !isFlutterSupported);
}
