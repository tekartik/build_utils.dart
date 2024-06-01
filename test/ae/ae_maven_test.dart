@TestOn('vm')
library;

import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/ae/ae_maven.dart';

void main() {
  group('ae_maven', () {
    test('AeMavenProject', () {
      var aeMaventProject = AeMavenProject('some_path');
      expect(aeMaventProject.path, 'some_path');
    });

    test('aeMvnArgs', () async {
      expect(aeMvnArgs(null), []);
      expect(aeMvnArgs(null, version: true), ['--version']);
      expect(aeMvnArgs([]), []);
      expect(aeMvnArgs(['dummy']), ['dummy']);
      expect(aeMvnArgs(['dummy'], version: true), ['--version', 'dummy']);
    });

    test('aeMvnRunArgs', () async {
      expect(aeMvnRunArgs(), ['-Dmaven.test.skip=true', 'appengine:run']);
    });

    test('aeMvnDeployArgs', () async {
      expect(aeMvnDeployArgs('project_id'), [
        '-Dmaven.test.skip=true',
        '-Dapp.deploy.project=project_id',
        'appengine:deploy'
      ]);
      expect(aeMvnDeployArgs('project_id', args: ['some_arg']), [
        '-Dmaven.test.skip=true',
        'some_arg',
        '-Dapp.deploy.project=project_id',
        'appengine:deploy'
      ]);
    });

    test('aeMvnDeployArgs', () async {
      expect(aeMvnDeployArgs('project_id', args: ['some_arg']), [
        '-Dmaven.test.skip=true',
        'some_arg',
        '-Dapp.deploy.project=project_id',
        'appengine:deploy'
      ]);
    });

    test('aeMvnTestArgs', () async {
      expect(aeMvnTestArgs(), ['-Dmaven.test.skip=false', 'test']);
    });
  });
}
