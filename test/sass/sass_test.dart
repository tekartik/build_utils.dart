@TestOn('vm')
library;

import 'package:tekartik_build_utils/sass/sass.dart';
import 'package:test/test.dart';

/*
main() {
  group('template', () {
    test('dir', () async {
      Directory top = await ctx.prepare();
      //Directory
      Directory dir = new Directory(join(top.path, 'dir'));

      await deleteDirectory(dir);
      expect(await dir.exists(), isFalse);

      File file = childFile(dir, "file");
      await writeString(file, "test");

      await dir.create();
      expect(await dir.exists(), isTrue);
      await deleteDirectory(dir);
      expect(await dir.exists(), isFalse);
      //print(top);
    });

    test('file', () async {
      Directory top = await ctx.prepare();
      File file = childFile(top, "file");
      expect(await file.exists(), isFalse);
      await writeString(file, "test");
      await deleteFile(file);
      expect(await file.exists(), isFalse);

      await deleteFile(file);
      expect(await file.exists(), isFalse);

      //print(top);
    });
  });
}
*/
void main() {
  bool? sassSupported;

  setUp(() async {
    sassSupported ??= await checkSassSupported();
  });

  test('checkSassSupported', () async {
    expect(await checkSassSupported(), sassSupported);
  });

  test('watch', () async {
    if (sassSupported!) {
      /*
      start
      await deleteFile(new File("kl"));
      ProcessResult result = await runCmd(gitVersionCmd());
      // git version 1.9.1
      expect(result.stdout.startsWith("git version"), isTrue);
      */
    }
  });
}
