import 'package:tekartik_build_utils/common_import.dart';
import 'package:tekartik_sc/git.dart';

gitLog() async {
  GitPath gitPath = GitPath();
  ProcessCmd cmd = gitPath.cmd(["log", '--format=format:%ai | %ae | %s']);
  await runCmd(cmd);
}
