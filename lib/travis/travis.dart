import 'dart:io';
import 'package:process_run/shell.dart'
    show runExecutableArgumentsSync, whichSync;
import 'package:tekartik_build_utils/shell/shell.dart';
import 'package:tekartik_common_utils/bool_utils.dart';

const String travisCommandName = 'travis';
String get travisExecutableName =>
    getBashOrBatExecutableFilename(travisCommandName);

bool? _isTravisSupported;

/// check if git is supported, only once
bool get isTravisSupportedSync =>
    _isTravisSupported ??= checkTravisSupportedSync();

bool checkTravisSupportedSync({bool? verbose}) {
  try {
    if (verbose == true) {
      stdout.writeln('\$ $travisExecutableName version');
    }
    // Not found: unsupported (nothing written by the shell).
    if (whichSync(travisExecutableName) == null) {
      return false;
    }
    var result = runExecutableArgumentsSync(travisExecutableName, ['version']);
    if (verbose == true) {
      stdout.writeln(result.stdout);
    }
    return result.exitCode == 0;
  } catch (_) {
    return false;
  }
}

/// Check whether we are currently running on travis
bool get runningInTravis {
  return parseBool(Platform.environment['TRAVIS']) == true;
}
