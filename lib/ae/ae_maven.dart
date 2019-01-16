import 'package:tekartik_build_utils/maven/maven.dart';
import 'package:tekartik_build_utils/maven/maven.dart' as common;

class AeMavenProject extends MavenProject {
  AeMavenProject(String path) : super(path);
}

List<String> aeMvnTestArgs({Iterable<String> args}) {
  List<String> mvnArgs = aeMvnArgs(args, skipTest: false);
  mvnArgs.add('test');
  return mvnArgs;
}

List<String> aeMvnDeployArgs(String projectId, {Iterable<String> args}) {
  List<String> mvnArgs = aeMvnArgs(args, skipTest: true);
  mvnArgs.add('-Dapp.deploy.project=$projectId');
  mvnArgs.add('appengine:deploy');
  return mvnArgs;
}

List<String> aeMvnGCloudDeployArgs(String projectId, {Iterable<String> args}) {
  List<String> mvnArgs = aeMvnArgs(args, skipTest: true);
  mvnArgs.add('-Dapp.deploy.project=$projectId');
  mvnArgs.add('gcloud:deploy');
  return mvnArgs;
}

Iterable<String> aeMvnRunArgs({Iterable<String> args}) {
  List<String> mvnArgs = aeMvnArgs(args, skipTest: true);
  mvnArgs.add('appengine:run');
  return mvnArgs;
}

List<String> aeMvnArgs(Iterable<String> args, {bool version, bool skipTest}) {
  List<String> mvnArgs = [];
  // --version          Print pub version.

  if (skipTest != null) {
    mvnArgs.add('-Dmaven.test.skip=$skipTest');
  }
  if (args != null) {
    mvnArgs.addAll(args);
  }

  mvnArgs = common.mvnArgs(mvnArgs, version: version);
  return mvnArgs;
}
