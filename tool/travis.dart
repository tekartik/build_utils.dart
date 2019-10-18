import 'package:process_run/shell.dart';

Future main() async {
  var shell = Shell();

  await shell.run('''
dartanalyzer --fatal-warnings --fatal-infos lib test example tool
pub run build_runner test -- -p vm
pub run test -p vm
''');
}
