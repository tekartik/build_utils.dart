import 'package:process_run/process_cmd.dart';
import 'package:process_run/process_run.dart';
import 'package:process_run/which.dart';
import 'package:tekartik_build_utils/shell/shell.dart';

@deprecated
ProcessCmd nodeCmd(List<String> args) {
  return ProcessCmd('node', args);
}

String get _nodeExecutableName => 'node';
String get _npmExecutableName => getBashOrCmdExecutableFilename('npm');

bool? _isNodeSupported;
bool get isNodeSupported => _isNodeSupported ??= whichSync('node') != null;

bool? _isNpmSupported;
bool get isNpmSupported => _isNpmSupported ??= whichSync('npm') != null;

///
/// build a node command
class NodeCmd extends ProcessCmd {
  // Somehow flutter requires runInShell on Linux, does not hurt on windows
  NodeCmd(List<String> arguments) : super(_nodeExecutableName, arguments);

  @override
  String toString() => executableArgumentsToString('node', arguments);
}

///
/// build a npm command
class NpmCmd extends ProcessCmd {
  // Somehow flutter requires runInShell on Linux, does not hurt on windows
  NpmCmd(List<String> arguments) : super(_npmExecutableName, arguments);

  @override
  String toString() => executableArgumentsToString('npm', arguments);
}
