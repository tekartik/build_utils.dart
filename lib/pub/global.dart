import 'package:dev_build/build_support.dart' show checkAndActivatePackage;
import 'package:tekartik_build_utils/common_import.dart';

Future<bool> isActivated(String packageName, {bool? verbose}) async {
  var lines = LineSplitter.split(
    (await runCmd(
      PubCmd(['global', 'list']),
      verbose: verbose,
    )).stdout.toString().trim(),
  );
  for (var line in lines) {
    if (line.split(' ')[0] == packageName) {
      return true;
    }
  }
  return false;
}

/// Activate [packageName] if not activated yet.
///
/// Uses dev_build lock: concurrent `dart pub global activate` of the same
/// package (test files run in parallel) fail with exit code 66 on a fresh pub
/// cache.
Future<void> activateIfNeeded(String packageName) async {
  await checkAndActivatePackage(packageName);
}
