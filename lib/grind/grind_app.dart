import 'package:grinder/grinder.dart';
import 'package:tekartik_build_utils/common_import.dart';
export 'package:grinder/grinder.dart' hide context, log, run;
export 'package:tekartik_build_utils/common_import.dart' hide context;
import 'package:tekartik_pub/io.dart';
import 'package:tekartik_deploy/fs_deploy.dart';
import 'package:tekartik_deploy/gs_deploy.dart';

class App {
  PubPackage pubPackage;
  String path = "web";
  //String fbPath = "gs://gs.tk4k.ovh/tmp";
  String gsPath = "gs://gs.tk4k.ovh/tmp";

  App() : pubPackage = new PubPackage(".");

  Future serve() async {
    await runCmd(pubPackage.pubCmd(["serve", "--hostname=0.0.0.0", path]));
  }

  String get deployPath => join("build", "deploy", path);
  String get fbDeployPath => join("build", "public", path);

  Future fsdeploy() async {
    try {
      await fsDeploy(
          yaml: new File(join('build', path, 'deploy.yaml')),
          dst: new Directory(deployPath));
    } catch (e) {
      stderr.writeln("make sure the project is built first");
      rethrow;
    }
  }

  // from deploy to public
  Future fspublicdeploy() async {
    try {
      await fsDeploy(
          options: fsDeployOptionsNoSymLink,
          src: new Directory(deployPath),
          dst: new Directory(fbDeployPath));
    } catch (e) {
      stderr.writeln("make sure the project is built first");
      rethrow;
    }
  }

  Future gswebdeploy() async {
    try {
      await gsWebDeploy(deployPath, gsPath);
    } catch (e) {
      stderr.writeln("make sure the project is built first");
      rethrow;
    }
  }

  Future build() async {
    await runCmd(pubPackage.pubCmd(["build", path]));
  }

  Future fbdeploy() async {
    await runCmd(processCmd("firebase", ['deploy', '--only', 'hosting']));
  }
}

App app = new App();

@Task('Set example project')
example() {
  app.path = "example";
}

@Task('Set web project')
web() {
  app.path = "web";
}

@Task('serve everything everywhere')
pubserve() async {
  //runCmd(pubCmd())
  await app.serve();
}

@Task('post build')
build() async {
  await app.build();
}

@Task('post build')
fsdeploy() async {
  await app.fsdeploy();
}

@Task('post build')
fbdeploy() async {
  await app.fbdeploy();
}

@Task('post build')
@Depends(fsdeploy)
fspublicdeploy() async {
  await app.fspublicdeploy();
}

@Task('Google Storate publishing')
@Depends(fsdeploy)
gswebdeploy() async {
  await app.gswebdeploy();
}

@Task('build and deploy')
@Depends(build, gswebdeploy)
gsall() async {}

@Task('build and deploy')
@Depends(build, fspublicdeploy, fbdeploy)
fball() async {}

/*
Future<bool> app(List<String> args) async {
  bool handled = false;
  return handled;
}
*/
@Task('Ping')
ping() async {
  print('pong');
}
