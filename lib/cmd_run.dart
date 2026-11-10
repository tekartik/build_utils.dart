import 'dart:io' as io;

import 'package:process_run/cmd_run.dart' hide runCmd;
import 'package:process_run/cmd_run.dart' as cmd_run show runCmd;
import 'package:tekartik_io_utils/io_utils_import.dart';

export 'package:process_run/cmd_run.dart' hide runCmd;

export 'shell/shell.dart';

/// Runs [cmd], verbose unless [verbose] is false (the working directory
/// printed too), and throws an [Exception] on a non zero exit code.
///
/// An error of the run (a missing executable...) is rethrown after a
/// `Cannot find command` message. Replaces process_run's own `runCmd`
/// (hidden by the export of this library).
Future<ProcessResult> runCmd(
  ProcessCmd cmd, {
  bool? verbose,
  bool? commandVerbose,
  Stream<List<int>>? stdin,
  StreamSink<List<int>>? stdout,
  StreamSink<List<int>>? stderr,
}) async {
  // Default to verbose on if null
  verbose = verbose != false;
  if (verbose && cmd.workingDirectory != null && cmd.workingDirectory != '.') {
    (stdout ?? io.stdout).add('\$ dir: [${cmd.workingDirectory}] \n'.codeUnits);
  }
  ProcessResult result;

  try {
    result = await cmd_run.runCmd(
      cmd,
      verbose: verbose,
      commandVerbose: commandVerbose,
      stdin: stdin,
      stdout: stdout,
      stderr: stderr,
    );
  } catch (e) {
    if (verbose) {
      (stderr ?? io.stderr).add(
        "Cannot find command '${cmd.toString().split(' ').first}'. Check installation\n"
            .codeUnits,
      );
    }
    rethrow;
  }

  if (result.exitCode != 0) {
    throw Exception('Exit code ${result.exitCode} running $cmd');
  }
  return result;
}
