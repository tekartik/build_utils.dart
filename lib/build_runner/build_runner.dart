import 'dart:async';

import 'package:tekartik_build_utils/cmd_run.dart';

Future pbr(List<String> arguments) async {
  await runCmd(PbrCmd(arguments));
}
