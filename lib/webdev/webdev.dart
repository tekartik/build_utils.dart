import 'dart:async';

import 'package:tekartik_build_utils/cmd_run.dart';

Future serve(List<String> directories) async {
  await runCmd(WebDevCmd(['serve']..addAll(directories)));
}
