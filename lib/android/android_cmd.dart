// User android_utils instead
@deprecated
import 'package:process_run/cmd_run.dart';

@deprecated
ProcessCmd adbCmd(List<String> args) {
  return ProcessCmd('adb', args);
}

@deprecated
List<String> adbMonkeyArgs({String packageName, int count}) {
  count ??= 50000;
  final args = <String>['shell', 'monkey'];
  if (packageName != null) {
    args.addAll(['-p', packageName]);

    args.addAll(['-v', '$count']);
  }
  return args;
}

// http://stackoverflow.com/questions/20155376/android-stop-emulator-from-command-line
// adb -s emulator-5554 emu kill
@deprecated
ProcessCmd killEmulator({String emulatorName}) {
  emulatorName ??= 'emulator-5554';
  return ProcessCmd('adb', ['-s', emulatorName, 'emu', 'kill']);
}

@deprecated
ProcessCmd nameApkCommand({String flavor}) {
  String filename;
  if (flavor == null) {
    filename = 'app-release';
  } else {
    filename = 'app-$flavor-release';
  }
  return ProcessCmd('apk_name_it', ['app/build/outputs/apk/$filename.apk']);
}
