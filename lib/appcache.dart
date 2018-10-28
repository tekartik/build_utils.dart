//import 'package:fs_shim/fs_io.dart';
import 'package:tekartik_io_utils/io_utils_import.dart';
import 'package:fs_shim/utils/io/entity.dart';
import 'package:fs_shim/utils/io/read_write.dart';

import 'package:path/path.dart';
import 'package:tekartik_deploy/fs_deploy.dart';

//import 'dart:io';

Future<int> fixAppCache({Map settings, File yaml, Directory src}) async {
  String manifestFileName = 'manifest.appcache';
  List<File> files =
      await fsDeployListFiles(settings: settings, yaml: yaml, src: src);
  if (src == null) {
    src = yaml.parent;
  }

  List<String> paths = [];

  for (File file in files) {
    String path = relative(file.path, from: src.path);
    //devPrint(path);
    // Never add the manifest file
    if (manifestFileName != path) {
      paths.add(path);
    }
  }

  /*
  Directory packageDir = new Directory(join(pubDir, 'lib'));

  List<String> files = [];
  await packageDir
      .list(recursive: true, followLinks: true)
      .listen((FileSystemEntity entity) {
    if (entity is Directory) {
      return;
    }
    String ext = extension(entity.path);
    switch (ext) {
      case '.html':
        return;
      case '.dart':
        return;
    }

    String path = relative(entity.path, from: packageDir.path);
    files.add(join(tradhivPackageTop, path));
  }).asFuture();
  // somehow...
  files.add('packages/polymer_elements/src/paper-menu/paper-menu-shared.css');
  */
  paths.add('# v ${DateTime.now()}');

  //print(files);

  List<String> output = [];
  File appCacheFile = childFile(src, manifestFileName);
  String appCache = await readString(appCacheFile);
  Iterable<String> lines = LineSplitter.split(appCache);
  bool replace = false;

  for (String line in lines) {
    if (line == "# end") {
      assert(replace == true);
      replace = false;
    } else if (line == "# start") {
      assert(replace == false);
      replace = true;
      // keep start
      output.add(line);
      output.addAll(paths);
    }
    if (!replace) {
      output.add(line);
    }
  }

  //print(appCache);
  //print(output);
  await writeString(appCacheFile, output.join('\n'));
  return files.length;
}
