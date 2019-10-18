//import 'package:fs_shim/fs_io.dart';
import 'package:fs_shim/utils/io/entity.dart';
import 'package:fs_shim/utils/io/read_write.dart';
import 'package:path/path.dart';
import 'package:tekartik_build_utils/src/appcache/appcache_impl.dart';
import 'package:tekartik_deploy/fs_deploy.dart';
import 'package:tekartik_io_utils/io_utils_import.dart';

//import 'dart:io';

///
/// Fix app cache manifest with current settings.
///
/// It takes files from the yaml file (typically deploy.yaml) with keys `files`
/// and `exclude`
///
/// It ignore files in `appcache_exclude`.
///
Future<int> fixAppCache({Map settings, File yaml, Directory src}) async {
  String manifestFileName = 'manifest.appcache';

  settings = await fixAppCacheSettings(settings, yaml: yaml);

  if (src == null) {
    src = yaml.parent;
  }

  List<File> files = await fsDeployListFiles(settings: settings, src: src);
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

  paths.add('# v ${DateTime.now()}');

  //print(files);

  File appCacheFile = childFile(src, manifestFileName);
  String appCache = await readString(appCacheFile);

  var output = appCacheLinesFromTemplate(appCache, paths);

  await writeString(appCacheFile, output.join('\n'));
  return files.length;
}
