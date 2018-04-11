//import 'package:process_run/cmd_run.dart' hide runCmd;
import '../chrome/chrome.dart' as chrome;
import 'package:grinder/grinder.dart';

@Task()
dartium() async {
  await chrome.dartium();
}
