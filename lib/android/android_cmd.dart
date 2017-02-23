import 'package:process_run/cmd_run.dart';

ProcessCmd adbCmd(List<String> args) {
  return new ProcessCmd('adb', args);
}

List<String> adbMonkeyArgs({String packageName, int count}) {
  count ??= 50000;
  List<String> args = ['shell', 'monkey'];
  if (packageName != null) {
    args.addAll(['-p', packageName]);

    args.addAll(['-v', "$count"]);
  }
  return args;
}

ProcessCmd nameApkCommand({String flavor}) {
  String filename;
  if (flavor == null) {
    filename = "app-release";
  } else {
    filename = "app-${flavor}-release";
  }
  return new ProcessCmd('apk_name_it', ['app/build/outputs/apk/$filename.apk']);
}
