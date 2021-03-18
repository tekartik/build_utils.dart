import 'package:tekartik_build_utils/common_import.dart';
import 'package:tekartik_sc/git.dart';

Future gitLog() async {
  final gitPath = GitPath('.');
  final cmd = gitPath.cmd(['log', '--format=format:%ai | %ae | %s']);
  await runCmd(cmd);
}
