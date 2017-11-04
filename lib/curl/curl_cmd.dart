import 'package:process_run/process_cmd.dart';

ProcessCmd curlCmd(List<String> args) {
  return new ProcessCmd('curl', args);
}
