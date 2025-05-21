import 'package:tekartik_build_utils/android/android_import.dart';
import 'package:tekartik_build_utils/appcache.dart';
import 'package:test/test.dart';

void main() {
  group('appcache', () {
    test('fixAppCache', () async {
      var dir = join('.dart_tool', 'tekartik_build_utils', 'test', 'appcache');
      await Directory(dir).create(recursive: true);
      await File(join(dir, 'manifest.appcache')).writeAsString('''
before
# start
test5
# end
after''');
      await File(join(dir, 'test1.txt')).writeAsString('content');
      await File(join(dir, 'test2.txt')).writeAsString('content');
      await File(join(dir, 'deploy.yaml')).writeAsString('''
files:
  - test1.txt''');
      await fixAppCache(yaml: File(join(dir, 'deploy.yaml')));
      expect(
        List<String>.from(
          LineSplitter.split(
            await File(join(dir, 'manifest.appcache')).readAsString(),
          ),
        )..removeAt(3),
        ['before', '# start', 'test1.txt', '# end', 'after'],
      );
    });
  });
}
