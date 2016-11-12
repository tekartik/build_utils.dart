@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/grind/grind_app.dart';

main() {
  group('grind_app', () {
    test('app', () {
      App app = new App();
      expect(app.path, "web");
      expect(app.gsPath, "gs://gs.tk4k.ovh/tmp");
      expect(app.deployPath, join("build", "deploy", "web"));

      app.path = "example";
      expect(app.deployPath, join("build", "deploy", "example"));

      app.path = join("example", "browser");
      expect(app.deployPath, join("build", "deploy", "example", "browser"));
    });
  });
}
