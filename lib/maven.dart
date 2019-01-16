import 'package:process_run/cmd_run.dart';

class MavenProject {
  final String path;
  MavenProject(this.path);

  ProcessCmd cmd(List<String> args) {
    return ProcessCmd('mvn', args, workingDirectory: path);
  }

  ProcessCmd testCmd() {
    return cmd(mvnArgs(['test']));
  }

  ProcessCmd serveCmd() {
    return cmd(mvnArgs(['appengine:devserver'], skipTest: true));
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

  //ProcessCmd deploySwagger()
}

List<String> mvnArgs(Iterable<String> args, {bool version, bool skipTest}) {
  List<String> mvnArgs = [];
  // --version          Print pub version.

  if (skipTest == true) {
    mvnArgs.add('-Dmaven.test.skip=true');
  }
  if (version == true) {
    mvnArgs.add('--version');
  }

  if (args != null) {
    mvnArgs.addAll(args);
  }

  return mvnArgs;
}
