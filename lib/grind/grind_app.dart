import 'package:grinder/grinder.dart';
import 'package:tekartik_build_utils/common_import.dart';
import 'package:tekartik_build_utils/target/app_host_target.dart';
import 'package:tekartik_deploy/fs_deploy.dart';
import 'package:tekartik_deploy/gs_deploy.dart';
import 'package:tekartik_pub/io.dart';
import 'package:tekartik_io_utils/dart_version.dart';

import '../appcache.dart';

export 'package:grinder/grinder.dart' hide context, log, run;
export 'package:tekartik_build_utils/common_import.dart' hide context;

class App {
  static String gsPathDefault = "gs://gs.tk4k.ovh/tmp";
  static String srcPathDefault = "web";

  bool _verbose;
  bool get verbose => _verbose == true;
  @deprecated
  set verbose(bool verbose) => _verbose = verbose;
  PubPackage pubPackage;
  AppHostTarget _target = AppHostTarget.dev;

  AppHostTarget get target => _target;

  set target(AppHostTarget target) {
    _target = target;
  }

  // if true build public upon build
  bool needBuildPublic;

  String gsSubPath;
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
    await runCmd(pubPackage
        .pubCmd(["serve", "--hostname=0.0.0.0", path, "--port=8060"]));
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
      stdout.writeln("public deploy to: $fbDeployPath");
      await fsDeploy(
          options: fsDeployOptionsNoSymLink,
          src: new Directory(deployPath),
          dst: new Directory(fbDeployPath));
    } catch (e) {
      stderr.writeln("make sure the project is built first");
      rethrow;
    }
  }

  String get gsWebDeployPath {
    String path = gsPath;
    if (gsSubPath != null) {
      path = url.join(gsPath, gsSubPath);
    }
    return path;
  }

  Future gswebdeploy() async {
    try {
      String path = gsWebDeployPath;
      await gsWebDeploy(deployPath, path);
    } catch (e) {
      stderr.writeln("make sure the project is built first");
      rethrow;
    }
  }

  Future postBuildStepOnly() async {
    if (await new File(join('build', path, 'deploy.yaml')).exists()) {
      if (await new File(join('build', path, 'manifest.appcache')).exists()) {
        await appcache();
      }
      await fsdeploy();
      if (needBuildPublic == true) {
        await this.fspublicdeploy();
      }
    }
  }

  Future build() async {
    if (dartVersion < new Version(2, 0, 0, pre: "dev.52")) {
      await runCmd(pubPackage.pubCmd(["build", path]), verbose: verbose);
    } else {
      await runCmd(
          pubPackage.pubCmd([
            "run",
            "build_runner",
            "build",
            "--release",
            "--output",
            "build"
          ]),
          verbose: verbose);
    }
    await postBuildStepOnly();
  }

  Future appcache() async {
    int count =
        await fixAppCache(yaml: new File(join('build', path, 'deploy.yaml')));
    stdout.writeln("appcache: ${count} file(s)");
  }

  Future fbdeploy() async {
    await runCmd(ProcessCmd("firebase", ['deploy', '--only', 'hosting']));
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

@Task("post build step only - typically deploy")
post_build_only() async {
  await app.postBuildStepOnly();
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
