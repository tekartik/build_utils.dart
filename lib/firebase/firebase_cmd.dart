import 'package:process_run/cmd_run.dart';
import 'package:process_run/process_cmd.dart';
import 'package:tekartik_build_utils/firebase/firebase.dart';

@deprecated
ProcessCmd firebaseCmd(List<String> args) => FirebaseCmd(args);

class FirebaseCmd extends ProcessCmd {
  FirebaseCmd(List<String> arguments)
      : super(firebaseExecutableName, arguments);

  @override
  String toString() =>
      executableArgumentsToString(firebaseCommandName, arguments);
}

// firebase deploy --only hosting
// Valid features for the --only flag are hosting, functions, database, storage, and firestore. These names correspond to the keys in your firebase.json configuration file.
List<String> firebaseArgs(
    {bool? deploy,
    bool? serve,
    bool? onlyFunctions,
    bool? onlyHosting,
    String? projectId}) {
  final args = <String>[];
  if (deploy ?? false) {
    if (serve ?? false) {
      throw ArgumentError('server and deploy cannot both be used');
    }
    args.add('deploy');
  } else if (serve ?? false) {
    args.add('serve');
  }

  var onlySb = StringBuffer();
  if (onlyFunctions ?? false) {
    onlySb.write('functions');
    //args.addAll(['--only', 'functions']);
  }
  if (onlyHosting ?? false) {
    if (onlySb.isNotEmpty) {
      onlySb.write(',');
    }
    onlySb.write('hosting');
    //args.addAll(['--only', 'hosting']);
  }
  if (onlySb.isNotEmpty) {
    args.addAll(['--only', onlySb.toString()]);
  }
  if (projectId != null) {
    args.addAll(['--project', projectId]);
  }
  return args;
}
