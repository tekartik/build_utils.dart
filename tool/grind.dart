import 'package:tekartik_build_utils/grind/grind_app.dart';
export 'package:tekartik_build_utils/grind/grind_app.dart';

main(List<String> args) async {
  //app.gsPath = "gs://gs.tk4k.ovh/tekartik_build_utils";
  //await ex_browser();
  await grind(args);
}

@Task('Test')
ex_browser() {
  app.gsPath = "gs://gs.tk4k.ovh/tekartik_build_utils/example/browser";
  app.path = join("example", "browser");
}
