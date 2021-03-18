import 'dart:io';
import 'package:process_run/shell.dart';
import 'package:tekartik_build_utils/shell/shell.dart';
import 'package:tekartik_common_utils/common_utils_import.dart';

const String fastlaneCommandName = 'fastlane';
String get fastlaneExecutableName =>
    getBashOrBatExecutableFilename(fastlaneCommandName);

bool? _isFastlaneSupported;

/// check if git is supported, only once
bool get isFastlaneSupportedSync =>
    _isFastlaneSupported ??= checkFastlaneSupportedSync();

bool checkFastlaneSupportedSync({bool? verbose}) {
  try {
    if (verbose == true) {
      stdout.writeln('\$ $fastlaneExecutableName --version');
    }
    var result = Process.runSync(fastlaneExecutableName, ['--version']);
    if (verbose == true) {
      stdout.writeln(result.stdout);
    }
    return result.exitCode == 0;
  } catch (_) {
    return false;
  }
}

/// Parse 'fastlane x.y.z' in fastlane call
Future<Version?> getFastlaneVersion() async {
  var result = await run('fastlane --version');
  Version? version;
  // Need to ignore fastlane installation at path:
  for (var line in result.outLines) {
    // Looking for fastlane 2.123.0
    var parts = line.trim().split(' ');
    if (parts.length == 2 && parts[0] == 'fastlane') {
      version = Version.parse(parts[1]);
    }
  }
  return version;
}
