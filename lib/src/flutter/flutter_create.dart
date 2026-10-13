import 'package:process_run/shell.dart';

/// The `flutter create` command line creating the project [appName] in
/// [dirName].
///
/// [options] are extra `flutter create` arguments, one argument per item.
String flutterCreateCommand({
  required String dirName,
  required String appName,
  List<String>? options,
}) => [
  'flutter',
  'create',
  ...?options,
  '--project-name',
  appName,
  dirName,
].map(shellArgument).join(' ');
