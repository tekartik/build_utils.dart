import 'dart:async';

import 'package:tekartik_build_utils/android/android_import.dart';
import 'package:tekartik_build_utils/cmd_run.dart';
import 'package:tekartik_build_utils/pub/global.dart';

Future serve(List<String> directories) async {
  await runCmd(WebDevCmd(['serve']..addAll(directories)));
}

bool _webdevActivated = false;

/// Then webdev can be used with 'pub global run webdev'
Future webdevActivate() async {
  if (!_webdevActivated) {
    await activateIfNeeded('webdev');
  }
}
