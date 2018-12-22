import 'dart:io';
import 'package:tekartik_build_utils/shell/shell.dart';

const String fastlaneCommandName = 'fastlane';
String get fastlaneExecutableName =>
    getBashOrBatExecutableFilename(fastlaneCommandName);

bool _isFastlaneSupported;

/// check if git is supported, only once
bool get isFastlaneSupportedSync =>
    _isFastlaneSupported ??= checkFastlaneSupportedSync();

bool checkFastlaneSupportedSync({bool verbose}) {
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
