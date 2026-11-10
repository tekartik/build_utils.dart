import 'dart:io';
import 'package:process_run/shell.dart'
    show runExecutableArgumentsSync, whichSync;
import 'package:tekartik_build_utils/shell/shell.dart';
export 'package:tekartik_build_utils/firebase/firebase_cmd.dart';

const String firebaseCommandName = 'firebase';
String get firebaseExecutableName =>
    getBashOrCmdExecutableFilename(firebaseCommandName);

bool? _isFirebaseSupported;

/// check if git is supported, only once
bool get isFirebaseSupportedSync =>
    _isFirebaseSupported ??= checkFirebaseSupportedSync();

bool checkFirebaseSupportedSync({bool? verbose}) {
  try {
    if (verbose == true) {
      stdout.writeln('\$ $firebaseExecutableName --version');
    }
    // Not found: unsupported (nothing written by the shell).
    if (whichSync(firebaseExecutableName) == null) {
      return false;
    }
    var result = runExecutableArgumentsSync(firebaseExecutableName, [
      '--version',
    ]);
    if (verbose == true) {
      stdout.writeln(result.stdout);
    }
    return result.exitCode == 0;
  } catch (_) {
    return false;
  }
}
