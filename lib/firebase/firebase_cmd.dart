import 'package:process_run/process_cmd.dart';

ProcessCmd firebaseCmd(List<String> args) {
  return new ProcessCmd('firebase', args);
}

// firebase deploy --only hosting
// Valid features for the --only flag are hosting, functions, database, storage, and firestore. These names correspond to the keys in your firebase.json configuration file.
List<String> firebaseArgs(
    {bool deploy, bool serve, bool onlyFunctions, bool onlyHosting}) {
  List<String> args = [];
  if (deploy ?? false) {
    if (serve ?? false) {
      throw new ArgumentError("server and deploy cannot both be used");
    }
    args.add('deploy');
  } else if (serve ?? false) {
    args.add('serve');
  }

  var onlySb = new StringBuffer();
  if (onlyFunctions ?? false) {
    onlySb.write('functions');
    //args.addAll(['--only', 'functions']);
  }
  if (onlyHosting ?? false) {
    if (onlySb.isNotEmpty) {
      onlySb.write(",");
    }
    onlySb.write('hosting');
    //args.addAll(['--only', 'hosting']);
  }
  if (onlySb.isNotEmpty) {
    args.addAll(['--only', onlySb.toString()]);
  }
  return args;
}
