import 'dart:io';

import 'package:tekartik_build_utils/flutter/app/generate.dart';

Future main() async {
  var dirName =
      '.dart_tool/tekartik_build_utils/example/flutter/app/tk_flutter_example_app';
  try {
    await Directory(dirName).delete(recursive: true);
  } catch (_) {}
  //expect(Directory(dirName).existsSync(), isFalse);
  await generate(dirName: dirName, force: true);
}
