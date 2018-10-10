import 'package:process_run/cmd_run.dart';
import 'package:tekartik_common_utils/common_utils_import.dart';

class MavenProject {
  final String path;
  MavenProject(this.path) {}

  ProcessCmd cmd(List<String> mvnArgs) {
    return ProcessCmd('mvn', mvnArgs, workingDirectory: path);
  }
}

List<String> mvnArgs(Iterable<String> args, {bool version}) {
  List<String> mvnArgs = [];

  if (version == true) {
    mvnArgs.add('--version');
  }

  if (args != null) {
    mvnArgs.addAll(args);
  }

  return mvnArgs;
}

Future<bool> checkMavenSupported({String executable, bool verbose}) async {
  try {
    MavenProject mavenProject = MavenProject(null);
    await runCmd(mavenProject.cmd(mvnArgs(null, version: true)),
        verbose: verbose);
    return true;
  } catch (e) {
    return false;
  }
}
