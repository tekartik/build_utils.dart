@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/maven/maven.dart';

void main() {
  bool? _isMavenSupported;

  setUp(() async {
    _isMavenSupported ??= await checkMavenSupported();
  });

  test('checkMavenSupported', () async {
    expect(await checkMavenSupported(), _isMavenSupported);
    //await runCmd(new MavenProject(null).cmd(mvnArgs(null, version: true)));
  });

  test('mvnArgs', () async {
    expect(mvnArgs(null), []);
    expect(mvnArgs(null, version: true), ['--version']);
    expect(mvnArgs([]), []);
    expect(mvnArgs(['dummy']), ['dummy']);
    expect(mvnArgs(['dummy'], version: true), ['--version', 'dummy']);
  });
}
