//import 'package:process_run/cmd_run.dart' hide runCmd;
import 'package:tekartik_build_utils/common_import.dart';
import 'package:tekartik_platform_io/context_io.dart';

Future dartium() async {
  await runCmd(ProcessCmd(
      "dartium", ['--disable-web-security', '--user-data-dir=~/.dartium_safe'],
      environment: {'DART_FLAGS': '--checked'}));
}

// Ubuntu 18.04 ok
Future chromium({bool noSecurity, String userDataDir}) async {
  noSecurity ??= false;

  var args = <String>[];
  if (noSecurity) {
    args.add('--disable-web-security');
    args.add('--allow-running-insecure-content');
    userDataDir ??= join(platformContextIo.userAppDataPath, 'tekartik',
        'chromium', 'no_security');
  }

  if (userDataDir != null) {
    args.add('--user-data-dir=$userDataDir');
  }
  await runCmd(ProcessCmd('chromium-browser', args));
}

// Ubuntu 18.04 ok
Future chrome({bool noSecurity, String userDataDir}) async {
  noSecurity ??= false;

  var args = <String>[];
  if (noSecurity) {
    args.add('--disable-web-security');
    args.add('--allow-running-insecure-content');
    userDataDir ??= join(
        platformContextIo.userAppDataPath, 'tekartik', 'chrome', 'no_security');
  }

  if (userDataDir != null) {
    args.add('--user-data-dir=$userDataDir');
  }
  await runCmd(ProcessCmd('google-chrome', args));
}
