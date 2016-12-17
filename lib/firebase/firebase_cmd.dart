import 'package:process_run/cmd_run.dart';

ProcessCmd firebaseCmd(List<String> args) {
  return new ProcessCmd('firebase', args);
}

List<String> firebaseArgs({bool deploy: false}) {
  List<String> args = [];
  if (deploy == true) {
    args.add('deploy');
  }
  return args;
}
