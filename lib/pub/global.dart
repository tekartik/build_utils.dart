import 'package:tekartik_build_utils/common_import.dart';

Future<bool> isActivated(String packageName) async {
  var lines = LineSplitter.split(
      (await runCmd(PubCmd(['global', 'list']))).stdout as String);
  for (var line in lines) {
    if (line.split(' ')[0] == packageName) {
      return true;
    }
  }
  return false;
}

Future activateIfNeeded(String packageName) async {
  if (!await isActivated(packageName)) {
    await runCmd(PubCmd(['global', 'activate', packageName]));
  }
}
