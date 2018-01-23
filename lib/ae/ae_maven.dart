import 'package:tekartik_build_utils/maven/maven.dart';
import 'package:tekartik_build_utils/maven/maven.dart' as common;

class AeMavenProject extends MavenProject {
  AeMavenProject(String path) : super(path) {}

  /*
  ProcessCmd testCmd() {
    return cmd(mvnArgs(['test', '-Dmaven.test.skip=false']));
  }


  ProcessCmd runCmd(List<String> args) {
    return cmd(aeMvnArgs(['appengine:devserver'], skipTest: true));
  }

  ProcessCmd appEngineEndpointsGetClientLibCmd() {
    return cmd(mvnArgs(['appengine:endpoints_get_client_lib']));
  }

  ProcessCmd appEngineEndpointsGetDiscoveryDocCmd() {
    return cmd(mvnArgs(['appengine:endpoints_get_discovery_doc']));
  }

  ProcessCmd validateCmd() {
    return cmd(mvnArgs(['validate']));
  }

  // new endpoints
  ProcessCmd cleanPackageCmd() {
    return cmd(mvnArgs(['clean', 'package']));
  }

  ProcessCmd getSwaggerDocCmd() {
    return cmd(mvnArgs(['exec:java', '-DGetSwaggerDoc']));
  }
  */

//ProcessCmd deploySwagger()
}

Iterable<String> aeMvnTestArgs({Iterable<String> args}) {
  List<String> mvnArgs = aeMvnArgs(args, skipTest: false);
  mvnArgs.add('test');
  return mvnArgs;
}

Iterable<String> aeMvnDeployArgs(String projectId, {Iterable<String> args}) {
  List<String> mvnArgs = aeMvnArgs(args, skipTest: true);
  mvnArgs.add('-Dapp.deploy.project=$projectId');
  mvnArgs.add('appengine:deploy');
  return mvnArgs;
}

Iterable<String> aeMvnGCloudDeployArgs(String projectId,
    {Iterable<String> args}) {
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

Iterable<String> aeMvnArgs(Iterable<String> args,
    {bool version, bool skipTest}) {
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
