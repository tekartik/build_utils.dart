import 'package:process_run/process_cmd.dart';

ProcessCmd nodeCmd(List<String> args) {
  return new ProcessCmd('node', args);
}