@TestOn('vm')
library;

import 'package:tekartik_build_utils/grind/grind_app.dart';
import 'package:tekartik_build_utils/target/app_host_target.dart';
import 'package:test/test.dart';

void main() {
  group('grind_app', () {
    test('app', () {
      final app = App();
      expect(app.path, 'web');
      expect(app.gsPath, 'gs://gs.tk4k.ovh/tmp-dev');
      expect(app.deployPath, join('build', 'deploy', 'web'));

      app.path = 'example';
      expect(app.deployPath, join('build', 'deploy', 'example'));

      app.path = join('example', 'browser');
      expect(app.deployPath, join('build', 'deploy', 'example', 'browser'));
    });

    test('target', () {
      final app = App();
      expect('${App.gsPathDefault}-dev', app.gsPath);
      app.target = AppHostTarget.staging;
      expect('${App.gsPathDefault}-staging', app.gsPath);
      app.target = AppHostTarget.dev;
      expect('${App.gsPathDefault}-dev', app.gsPath);
      app.target = AppHostTarget.prod;
      expect(App.gsPathDefault, app.gsPath);
    });

    test('gsWebDeployPath', () {
      final app = App();
      expect('${App.gsPathDefault}-dev', app.gsWebDeployPath);
      app.gsSubPath = 'sub';
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
