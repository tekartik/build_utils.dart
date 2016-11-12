import 'package:grinder/grinder.dart';
import 'package:tekartik_build_utils/common_import.dart';
export 'package:grinder/grinder.dart' hide context, log, run;
export 'package:tekartik_build_utils/common_import.dart' hide context;
import 'package:tekartik_pub/io.dart';

class App {
  PubPackage pubPackage;
  String path = "web";

  App() : pubPackage = new PubPackage(".");

  Future serve() async {
    await runCmd(pubPackage.pubCmd(["serve", "--hostname=0.0.0.0", path]));
  }
}

App app = new App();

@Task('Set example project')
example() {
  app.path = "example";
}

@Task('serve everything everywhere')
pubserve() async {
  //runCmd(pubCmd())
  await app.serve();
}

/*
Future<bool> app(List<String> args) async {
  bool handled = false;
  return handled;
}
*/
@Task('Ping')
ping() async {
  devPrint('ping');
}
