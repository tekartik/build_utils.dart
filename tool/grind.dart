import 'package:tekartik_build_utils/grind/grind_app.dart';
export 'package:tekartik_build_utils/grind/grind_app.dart';

class MyApp extends App {
  @override
  Future build() async {
    await super.build();
    print("### custom build step");

  }
}
main(List<String> args) async {
  app = new MyApp();
  //app.gsPath = "gs://gs.tk4k.ovh/tekartik_build_utils";
  //await ex_browser();
  await grind(args);
}

@Task('Test')
example_browser() {
  app.gsPath = "gs://gs.tk4k.ovh/tekartik_build_utils/example/browser";
  app.path = join("example", "browser");
}
