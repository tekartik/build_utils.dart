//import 'package:process_run/cmd_run.dart' hide runCmd;
import 'package:tekartik_build_utils/common_import.dart';

dartium() {
  runCmd(processCmd(
      "dartium", ['--disable-web-security', '--user-data-dir=~/.dartium_safe'],
      environment: {'DART_FLAGS': '--checked'}));
}
