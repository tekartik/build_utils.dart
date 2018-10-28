import 'package:tekartik_build_utils/grind/grind_app.dart';
import 'package:tekartik_build_utils/target/app_host_target.dart';
export 'package:tekartik_build_utils/grind/grind_app.dart';

class MyApp extends App {
  MyApp() {
    //gsPath = "gs://gs.tk4k.ovh/tekartik_build_utils";
    //verbose = true;
  }
  @override
  Future build() async {
    await super.build();
    print("### custom build step");
  }
}

main(List<String> args) async {
  app = MyApp();
  //app.gsPath = "gs://gs.tk4k.ovh/tekartik_build_utils";
  //await ex_browser();
  await grind(args);
}

@Task('Test')
example_browser() {
  if (app.target == AppHostTarget.prod) {
    app.gsPath = "gs://gs.tk4k.ovh/tekartik_build_utils/example_browser";
  } else if (app.target == AppHostTarget.staging) {
    app.gsPath = "gs://gs.tk4k.ovh/tekartik_build_utils";
    app.gsSubPath = "sub";
  } else {
    app.gsPath = "gs://gs.tk4k.ovh/tekartik_build_utils/example/browser";
  }

  app.path = join("example", "browser");
  print('example_browser: ${app.path} ${app.gsPath} ${app.target}');
}

@DefaultTask()
none() {}
