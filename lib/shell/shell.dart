import 'dart:io';

import 'package:path/path.dart';

/// 'gradle' => 'gradlew.bat' (windows) or 'gradle'
String getBashOrBatExecutableFilename(String command) {
  return Platform.isWindows ? '$command.bat' : command;
}

/// 'firebase' => 'firebase.cmd' (windows) or firebase'
String getBashOrCmdExecutableFilename(String command) {
  return Platform.isWindows ? '$command.cmd' : command;
}

/// To move to process_run?
String? executableInPathSync(String executable, String path) {
  var fullPath = join(path, executable);
  if (File(fullPath).existsSync()) {
    return fullPath;
  }

  List<String> extensions;
  if (Platform.isWindows) {
    extensions = ['.exe', '.bat', '.cmd', '.com'];
  } else {
    extensions = ['.sh'];
  }
  for (var ext in extensions) {
    var fullPath = join(path, executable, ext);
    if (File(fullPath).existsSync()) {
      return fullPath;
    }
  }
  return null;
}
