import 'package:grinder/grinder.dart';
import 'package:tekartik_build_utils/common_import.dart';
export 'package:grinder/grinder.dart' hide context, log, run;
export 'package:tekartik_build_utils/common_import.dart' hide context;
export 'package:tekartik_app_utils/app_host_target.dart';
import 'package:tekartik_pub/io.dart';
import 'package:tekartik_deploy/fs_deploy.dart';
import 'package:tekartik_deploy/gs_deploy.dart';
import '../appcache.dart';
import 'package:tekartik_app_utils/app_host_target.dart';

class App {
  static String gsPathDefault = "gs://gs.tk4k.ovh/tmp";
  static String srcPathDefault = "web";

  PubPackage pubPackage;
  AppHostTarget _target = AppHostTarget.dev;

  AppHostTarget get target => _target;

  set target(AppHostTarget target) {
    _target = target;
  }

  String path = "web";
  //String fbPath = "gs://gs.tk4k.ovh/tmp";
  String _gsPath = gsPathDefault;

  String get gsPath {
    if (target == null || target == AppHostTarget.prod) {
      return _gsPath;
    }
    return "${_gsPath}-${target.value}";
  }

  set gsPath(String gsPath) {
    this._gsPath = gsPath;
  }

  App() : pubPackage = new PubPackage(".");

  Future serve() async {
    await runCmd(pubPackage.pubCmd(["serve", "--hostname=0.0.0.0", path]));
  }

  String get deployPath => join("build", "deploy", path);
  String get fbDeployPath => join("build", "public", path);

  Future fsdeploy() async {
    try {
      int count = await fsDeploy(
          yaml: new File(join('build', path, 'deploy.yaml')),
          dst: new Directory(deployPath));
      stdout.writeln("fsdeploy: ${count} file(s)");
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
    if (await new File(join('build', path, 'deploy.yaml')).exists()) {
      if (await new File(join('build', path, 'manifest.appcache')).exists()) {
        await appcache();
      }
      await fsdeploy();
    }
  }

  Future appcache() async {
    int count =
        await fixAppCache(yaml: new File(join('build', path, 'deploy.yaml')));
    stdout.writeln("appcache: ${count} file(s)");
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

@Task('appcache')
appcache() async {
  await app.appcache();
}

@Task('post build')
fbdeploy() async {
  await app.fbdeploy();
}

@Task('post build')
fspublicdeploy() async {
  await app.fspublicdeploy();
}

@Task('Google Storate publishing')
gswebdeploy() async {
  await app.gswebdeploy();
}

@Task('build and deploy')
@Depends(build, gswebdeploy)
gsall() async {}

@Task('build and deploy public')
@Depends(build, fspublicdeploy)
fsall() async {}

@Task('build and deploy')
@Depends(fsall, fbdeploy)
fball() async {}

@Task('staging')
staging() async {
  print("=========");
  print(" STAGING ");
  print("=========");
  app.target = AppHostTarget.staging;
}

@Task('prod')
prod() async {
  print("=========");
  print("  PROD   ");
  print("=========");
  app.target = AppHostTarget.prod;
}

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
