@TestOn('vm')
library;

import 'package:tekartik_build_utils/maven/maven.dart';
import 'package:test/test.dart';

void main() {
  bool? isMavenSupported;

  setUp(() async {
    isMavenSupported ??= await checkMavenSupported();
  });

  test('checkMavenSupported', () async {
    expect(await checkMavenSupported(), isMavenSupported);
    //await runCmd(new MavenProject(null).cmd(mvnArgs(null, version: true)));
  });

  test('mvnArgs', () async {
    expect(mvnArgs(null), isEmpty);
    expect(mvnArgs(null, version: true), ['--version']);
    expect(mvnArgs([]), isEmpty);
    expect(mvnArgs(['dummy']), ['dummy']);
    expect(mvnArgs(['dummy'], version: true), ['--version', 'dummy']);
  });
}
