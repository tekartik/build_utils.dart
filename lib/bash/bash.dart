import 'package:path/path.dart';
import 'package:process_run/cmd_run.dart';
import 'package:tekartik_io_utils/io_utils_import.dart';

Future<ProcessResult> bash(String commands,
    {bool verbose, String workingDirectory}) async {
  Directory directory = await Directory.systemTemp.createTemp("tekartik_bash");
  File file = File(join(directory.path, "script.sh"));

  String bashContent = '''
#!/usr/bin/env bash
$commands
''';
  if (verbose) {
    stdout.writeln(bashContent);
  }
  await file.writeAsString(bashContent);

  Map<String, String> env = Map.from(Platform.environment);
  // add dart path
  env['PATH'] = "${dirname(dartExecutable)}:${env['PATH']}";
  var cmd = ProcessCmd("bash", [file.path],
      environment: env, workingDirectory: workingDirectory);
  var result = await runCmd(cmd, verbose: verbose);
  if (result.exitCode != 0) {
    throw Exception("exit code ${result.exitCode} for $bashContent");
  }

  //await directory.delete(recursive: true);
  return result;
}
