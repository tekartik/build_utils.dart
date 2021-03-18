import 'package:tekartik_build_utils/common_import.dart';

Future<bool> isActivated(String packageName, {bool? verbose}) async {
  var lines = LineSplitter.split(
      (await runCmd(PubCmd(['global', 'list']), verbose: verbose))
          .stdout
          .toString()
          .trim());
  for (var line in lines) {
    if (line.split(' ')[0] == packageName) {
      return true;
    }
  }
  return false;
}

Future activateIfNeeded(String packageName) async {
  if (!await isActivated(packageName, verbose: false)) {
    await runCmd(PubCmd(['global', 'activate', packageName]));
  }
}
