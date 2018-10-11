import 'dart:io';

/// 'gradle' => 'gradlew.bat' (windows) or 'gradle'
String getBashOrBatExecutableFilename(String command) {
  return Platform.isWindows ? '$command.bat' : command;
}

/// 'firebase' => 'firebase.cmd' (windows) or firebase'
String getBashOrCmdExecutableFilename(String command) {
  return Platform.isWindows ? '$command.cmd' : command;
}
