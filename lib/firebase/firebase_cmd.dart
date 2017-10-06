import 'package:process_run/process_cmd.dart';

ProcessCmd firebaseCmd(List<String> args) {
  return new ProcessCmd('firebase', args);
}

List<String> firebaseArgs({bool deploy, bool serve, bool onlyFunctions}) {
  List<String> args = [];
  if (deploy ?? false) {
    if (serve ?? false) {
      throw new ArgumentError("server and deploy cannot both be used");
    }
    args.add('deploy');
  } else if (serve ?? false) {
    args.add('serve');
  }

  if (onlyFunctions ?? false) {
    args.addAll(['--only', 'functions']);
  }
  return args;
}
