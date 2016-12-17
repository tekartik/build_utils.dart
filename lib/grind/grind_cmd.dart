import 'package:process_run/cmd_run.dart';

const String grindExecutableName = "grind";

ProcessCmd grindCmd([List<String> args]) {
  List<String> grindArgs = pubGrindArgs(args);
  return pubCmd(grindArgs);
}

List<String> pubGrindArgs([List<String> args]) {
  List<String> grindArgs = ['run', 'grinder:grinder'];
  if (args != null) {
    grindArgs.addAll(args);
  }
  return grindArgs;
}
