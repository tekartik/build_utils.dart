import 'package:process_run/cmd_run.dart';

const String grindExecutableName = "grind";

grindCmd([List<String> args]) {
  List<String> grindArgs = ['run', 'grinder'];
  if (args != null) {
    grindArgs.addAll(args);
  }
  return pubCmd(grindArgs);
}
