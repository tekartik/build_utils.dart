import 'package:process_run/cmd_run.dart';

const String grindExecutableName = 'grind';

ProcessCmd grindCmd([List<String>? args]) {
  final grindArgs = pubGrindArgs(args);
  return PubCmd(grindArgs);
}

List<String> pubGrindArgs([List<String>? args]) {
  final grindArgs = ['run', 'grinder:grinder'];
  if (args != null) {
    grindArgs.addAll(args);
  }
  return grindArgs;
}
