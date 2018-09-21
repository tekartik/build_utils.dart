import 'dart:io';

/// 'gradle' => 'gradlew.bat' or 'gradle'
String getBashOrBatExecutableFilename(String command) {
  return Platform.isWindows ? '$command.bat' : command;
}
