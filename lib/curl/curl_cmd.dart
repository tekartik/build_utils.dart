import 'package:process_run/process_cmd.dart';

ProcessCmd curlCmd(List<String> args) {
  return ProcessCmd('curl', args);
}
