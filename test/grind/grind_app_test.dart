@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/grind/grind_app.dart';
import 'package:tekartik_build_utils/target/app_host_target.dart';

main() {
  group('grind_app', () {
    test('app', () {
      App app = App();
      expect(app.path, "web");
      expect(app.gsPath, "gs://gs.tk4k.ovh/tmp-dev");
      expect(app.deployPath, join("build", "deploy", "web"));

      app.path = "example";
      expect(app.deployPath, join("build", "deploy", "example"));

      app.path = join("example", "browser");
      expect(app.deployPath, join("build", "deploy", "example", "browser"));
    });

    test('target', () {
      App app = App();
      expect('${App.gsPathDefault}-dev', app.gsPath);
      app.target = AppHostTarget.staging;
      expect('${App.gsPathDefault}-staging', app.gsPath);
      app.target = AppHostTarget.dev;
      expect('${App.gsPathDefault}-dev', app.gsPath);
      app.target = AppHostTarget.prod;
      expect(App.gsPathDefault, app.gsPath);
    });

    test('gsWebDeployPath', () {
      App app = App();
      expect('${App.gsPathDefault}-dev', app.gsWebDeployPath);
      app.gsSubPath = "sub";
      expect('${App.gsPathDefault}-dev/sub', app.gsWebDeployPath);
      /*
      app.target = AppHostTarget.staging;
      expect('${App.gsPathDefault}-staging', app.gsPath);
      app.target = AppHostTarget.dev;
      expect('${App.gsPathDefault}-dev', app.gsPath);
      app.target = AppHostTarget.prod;
      expect(App.gsPathDefault, app.gsPath);
      */
    });
  });
}
