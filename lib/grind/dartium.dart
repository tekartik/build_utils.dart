//import 'package:process_run/cmd_run.dart' hide runCmd;
import 'dart:async';

import 'package:grinder/grinder.dart';

import 'package:tekartik_build_utils/chrome/chrome.dart' as chrome;

@Task()
Future dartium() async {
  await chrome.dartium();
}
