import 'package:tekartik_io_utils/io_utils_import.dart';
export 'package:process_run/cmd_run.dart' hide runCmd;
export 'shell/shell.dart';
import 'package:process_run/cmd_run.dart' hide runCmd;
import 'package:process_run/cmd_run.dart' as cmd_run show runCmd;
import 'dart:io' as io;

// verbose run with exit on fail
Future<ProcessResult> runCmd(ProcessCmd cmd,
    {bool verbose,
    bool commandVerbose,
    Stream<List<int>> stdin,
    StreamSink<List<int>> stdout,
    StreamSink<List<int>> stderr}) async {
  // Default to verbose on if null
  verbose = verbose != false;
  if (verbose && cmd.workingDirectory != null && cmd.workingDirectory != ".") {
    (stdout ?? io.stdout).add("\$ dir: [${cmd.workingDirectory}] \n".codeUnits);
  }
  ProcessResult result = await cmd_run.runCmd(cmd,
      verbose: verbose,
      commandVerbose: commandVerbose,
      stdin: stdin,
      stdout: stdout,
      stderr: stderr);

  if (result.exitCode != 0) {
    exit(result.exitCode);
  }
  return result;
}
