import 'dart:async';
import 'package:process_run/cmd_run.dart';

String _sassExecutable = 'sass';

String sassExecutableThatWillNeverExists = '/tekartik/dummy/sass';

// [version] means show version used for supported
ProcessCmd sassCmd({String? watch, bool? version, String? executable}) {
  executable ??= _sassExecutable;
  final args = <String>[];
  if (watch != null) {
    args.addAll(['--watch', watch]);
  }
  if (version == true) {
    args.add('--version');
  }
  return ProcessCmd(executable, args);
}

Future<bool> checkSassSupported({String? executable, bool? verbose}) async {
  try {
    await runCmd(sassCmd(executable: executable, version: true),
        verbose: verbose);
    return true;
  } catch (e) {
    return false;
  }
}
