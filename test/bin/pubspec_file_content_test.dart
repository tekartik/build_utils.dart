import 'package:tekartik_build_utils/bin/pubspec_file_content.dart';
import 'package:tekartik_build_utils/common_import.dart';
import 'package:test/test.dart';

void main() {
  group('pubspec_file_content', () {
    test('min_sdk', () async {
      var content = PubspecFileContent.inMemory()..lines = [];
      expect(content.updateDartSdk(minVersion: Version(1, 0, 0)), false);
      expect(content.lines, isEmpty);
      content.lines = ['environment:', '  sdk:'];
      expect(content.updateDartSdk(minVersion: Version(1, 0, 0)), true);
      content.lines = ['name: abc', 'pedigree: none'];
    });
    test('min_sdk not first in environment', () async {
      for (var environment in [
        ['  flutter: ">=3.0.0"', '  sdk: ^3.0.0'],
        ['  # min', '  sdk: ^3.0.0'],
        ['', '  sdk: ^3.0.0'],
      ]) {
        var content = PubspecFileContent.inMemory()
          ..lines = ['name: x', 'environment:', ...environment, 'other: 1'];
        expect(
          content.updateDartSdk(minVersion: Version(3, 12, 0)),
          isTrue,
          reason: '$environment',
        );
        expect(content.lines, [
          'name: x',
          'environment:',
          environment.first,
          "  sdk: '^3.12.0'",
          'other: 1',
        ]);
      }
      // Not looked for after the environment block.
      var content = PubspecFileContent.inMemory()
        ..lines = ['environment:', '  flutter: any', 'other:', '  sdk: any'];
      expect(content.updateDartSdk(minVersion: Version(3, 12, 0)), isFalse);
    });
    test('publish_to_none', () async {
      var content = PubspecFileContent.inMemory()..lines = [];
      expect(content.addPublishToNone(), true);
      expect(content.lines, ['publish_to: none']);
      expect(content.addPublishToNone(), false);
      content.lines = ['name: abc', 'pedigree: none'];
      expect(content.addPublishToNone(), true);
      expect(content.lines, [
        'name: abc',
        'publish_to: none',
        'pedigree: none',
      ]);
      expect(content.addPublishToNone(), false);
    });
  });
}
