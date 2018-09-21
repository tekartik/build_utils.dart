//import 'package:process_run/cmd_run.dart' hide runCmd;
import 'package:grinder/grinder.dart';
import 'package:tekartik_build_utils/common_import.dart';

@Task()
chromium() {
  runCmd(ProcessCmd("chromium-browser",
      ['--disable-web-security', '--user-data-dir', '~/.chromium_safe'],
      environment: {'DART_FLAGS': '--checked'}));
}
