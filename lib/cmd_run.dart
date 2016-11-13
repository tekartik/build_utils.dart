import 'package:tekartik_io_utils/io_utils_import.dart';
export 'package:process_run/cmd_run.dart' hide runCmd;
import 'package:process_run/cmd_run.dart' hide runCmd;
import 'package:process_run/cmd_run.dart' as cmd_run show runCmd;

// verbose run with exit on fail
Future<ProcessResult> runCmd(ProcessCmd cmd,
    {bool verbose,
    bool commandVerbose,
    Stream<List<int>> stdin,
    StreamSink<List<int>> stdout,
    StreamSink<List<int>> stderr}) async {
  ProcessResult result = await cmd_run.runCmd(cmd,
      verbose: verbose != false, stdin: stdin, stdout: stdout, stderr: stderr);
  if (result.exitCode != 0) {
    exit(result.exitCode);
  }
  return result;
}
