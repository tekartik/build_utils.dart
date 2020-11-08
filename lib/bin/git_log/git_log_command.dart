import 'package:tekartik_build_utils/bin/process_run_import.dart';
import 'package:tekartik_build_utils/common_import.dart';
import 'package:tekartik_build_utils/git/git_log.dart';

Version gitLogBinVersion = Version(0, 1, 0);

String get script => 'git_log';

class MainShellCommand extends ShellBinCommand {
  MainShellCommand() : super(name: script, version: gitLogBinVersion);

  @override
  FutureOr<bool> onRun() async {
    await gitLog();
    return true;
  }
}

/// Direct shell env Alias dump run helper for testing.
Future<void> main(List<String> arguments) async {
  await MainShellCommand().parseAndRun(arguments);
}
