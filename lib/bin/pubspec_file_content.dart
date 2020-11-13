import 'package:tekartik_build_utils/bin/process_run_import.dart';
import 'package:tekartik_build_utils/common_import.dart';
import 'package:yaml/yaml.dart';
import 'package:collection/collection.dart';

class PubspecFileContent extends FileContent {
  PubspecFileContent(String path) : super(path);

  /// Supported top level [configKeys]
  bool updateDartSdk({Version minVersion}) {
    var key = 'sdk';
    // Remove alias header
    var modified = false;
    var index = indexOfTopLevelKey(['environment']);
    if (index >= 0) {
      // Skip top level key
      index++;
      // Remove existing alias
      for (var i = index; i < lines.length; i++) {
        // Until first non space, non comment stat
        var line = lines[i];
        if (FileContent.isTopLevelKey(line)) {
          break;
        } else {
          // Looking for sdk: xxxx
          dynamic yaml;
          try {
            yaml = loadYaml(line);
          } catch (_) {}
          if (yaml is Map &&
              const ListEquality().equals(yaml.keys.toList(), [key])) {
            var boundaries = VersionBoundaries.tryParse(yaml[key]?.toString());
            if (boundaries != null) {
              boundaries = VersionBoundaries(
                  VersionBoundary(minVersion, true), boundaries.max);
              var newLine = '  sdk: \'$boundaries\'';
              modified = true;
              lines[i] = newLine;
            }
          }

          break;
        }
      }
    } else {
      stderr.writeln('environment not found');
    }
    return modified;
  }
}
