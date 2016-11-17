@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/grind/grind_app.dart';

main() {
  group('grind_app', () {
    test('app', () {
      App app = new App();
      expect(app.path, "web");
      expect(app.gsPath, "gs://gs.tk4k.ovh/tmp-dev");
      expect(app.deployPath, join("build", "deploy", "web"));

      app.path = "example";
      expect(app.deployPath, join("build", "deploy", "example"));

      app.path = join("example", "browser");
      expect(app.deployPath, join("build", "deploy", "example", "browser"));
    });

    test('target', () {
      App app = new App();
      expect('${App.gsPathDefault}-dev', app.gsPath);
      app.target = AppHostTarget.staging;
      expect('${App.gsPathDefault}-staging', app.gsPath);
      app.target = AppHostTarget.dev;
      expect('${App.gsPathDefault}-dev', app.gsPath);
      app.target = AppHostTarget.prod;
      expect(App.gsPathDefault, app.gsPath);
    });
  });
}
