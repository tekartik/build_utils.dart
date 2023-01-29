import 'package:collection/collection.dart';
import 'package:tekartik_build_utils/bin/process_run_import.dart';
import 'package:tekartik_build_utils/common_import.dart';
import 'package:yaml/yaml.dart';

class PubspecFileContent extends FileContent {
  PubspecFileContent(String path) : super(path);

  PubspecFileContent.inMemory() : super('');

  /// Supported top level [configKeys]
  bool updateDartSdk({required Version minVersion}) {
    var key = 'sdk';
    // Remove alias header
    var modified = false;
    var index = indexOfTopLevelKey(['environment']);
    if (index >= 0) {
      // Skip top level key
      index++;
      // Remove existing alias
      // ignore: dead_code
      for (var i = index; i < lines!.length; i++) {
        // Until first non space, non comment stat
        var line = lines![i];
        if (FileContent.isTopLevelKey(line)) {
          break;
        } else {
          // Looking for sdk: xxxx
          dynamic yaml;
          try {
            yaml = loadYaml(line);
          } catch (_) {}
          if (yaml is Map &&
              const ListEquality<Object?>().equals(yaml.keys.toList(), [key])) {
            var sdkRawBoundaries = yaml[key]?.toString();
            VersionBoundaries? boundaries;
            if (sdkRawBoundaries != null) {
              boundaries = VersionBoundaries.tryParse(sdkRawBoundaries)!;
            }

            // Create boundaries if needed limiting max to the next major version
            boundaries ??= VersionBoundaries(null,
                VersionBoundary(Version(minVersion.major + 1, 0, 0), false));

            boundaries = VersionBoundaries(
                VersionBoundary(minVersion, true), boundaries.max);
            var newLine = '  sdk: \'$boundaries\'';
            modified = true;
            lines![i] = newLine;
          }

          break;
        }
      }
    } else {
      stderr.writeln('environment not found');
    }
    return modified;
  }

  String _getListKeyName(String line) => line.trim().split(':').first;

  var publishToKey = 'publish_to';

  bool addPublishToNone() {
    for (var line in lines!) {
      if (FileContent.isTopLevelKey(line)) {
        if (_getListKeyName(line) == publishToKey) {
          stderr.writeln('existing: $line');
          return false;
        }
      }
    }
    var bestInsertIndex = 0;
    var firstHeaders = ['name', 'description', 'version', 'homepage', 'author'];
    // Skip the main ones
    for (var i = 0; i < lines!.length; i++) {
      var line = lines![i];
      if (FileContent.isTopLevelKey(line)) {
        if (firstHeaders.contains(_getListKeyName(line))) {
          bestInsertIndex = i + 1;
          continue;
        }
        break;
      }
    }
    lines!.insert(bestInsertIndex, 'publish_to: none');
    return true;
  }
}
