import 'package:tekartik_build_utils/bin/pubspec_file_content.dart';
import 'package:test/test.dart';

void main() {
  group('pubspec_file_content', () {
    test('version', () async {
      var content = PubspecFileContent.inMemory()..lines = [];
      expect(content.addPublishToNone(), true);
      expect(content.lines, ['publish_to: none']);
      expect(content.addPublishToNone(), false);
      content.lines = ['name: abc', 'pedigree: none'];
      expect(content.addPublishToNone(), true);
      expect(
          content.lines, ['name: abc', 'publish_to: none', 'pedigree: none']);
      expect(content.addPublishToNone(), false);
    });
  });
}
