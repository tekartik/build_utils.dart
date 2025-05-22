import 'package:fs_shim/utils/io/copy.dart';
import 'package:process_run/shell_run.dart';
import 'package:tekartik_build_utils/android/android_import.dart';
import 'package:tekartik_build_utils/flutter/flutter.dart';
import 'package:tekartik_prj_tktools/dtk/dtk_prj.dart';
//import 'package:tekartik_build_utils/android/android_import.dart' hide run;

// Future<_Context>
Future<bool> generate({
  required String dirName,
  String? appName,
  List<String>? options,
  bool? force,
  // soon deprecated
  @Deprecated('not supported') bool? noWeb,
}) async {
  force ??= false;
  appName ??= basename(dirName);
  noWeb ??= false;
  dirName = _fixDirName(dirName);

  var context = await flutterContext;

  if ((!noWeb) && (context.version! < Version(1, 10, 1))) {
    throw 'invalid flutter version ${context.version}';
  }
  // var shell = Shell();
  if (!force) {
    print('Create $appName in $dirName. Continue Y/N?');

    var input = stdin.readLineSync()!;
    if (input.toLowerCase() != 'y') {
      return false;
    }
  }
  try {
    await Directory(dirName).delete(recursive: true);
  } catch (_) {}
  try {
    await Directory(dirname(dirName)).create(recursive: true);
  } catch (_) {}
  var shell = Shell(workingDirectory: dirname(dirName));

  var options = <String>[];

  await shell.run(
    'flutter create ${options.join(' ')} --project-name $appName $dirName',
  );

  print('continued');
  return true;
}

String _fixDirName(String dirName) => normalize(absolute(dirName));

/// Generate a flutter project and override with existing dir
Future fsGenerate({
  required String dir,
  String? package,
  required String src,
}) async {
  if (!await generate(dirName: dir, appName: package, force: true)) {
    return;
  }

  await copyDirectory(Directory(src), Directory(dir));

  // Check some essentials file
  for (var file in ['README.md', 'pubspec.yaml', join('lib', 'main.dart')]) {
    var ioFile = File(join(src, file));
    if (ioFile.existsSync()) {
      if ((await File(join(dir, file)).readAsString()) !=
          (await ioFile.readAsString())) {
        throw StateError('content of $file not copied');
      }
    }
  }
  var dtkProject = DtkProject(dir);
  await dtkProject.removeFromWorkspace();
  var shell = Shell(workingDirectory: dir);

  // Get it
  await shell.run('flutter packages get');
}

Future gitGenerate({
  String? dirName,
  String? appName,
  bool? force,
  @Deprecated('not supported') bool? noWeb,
}) async {
  force ??= false;
  if (!force) {
    var file = join(dirName!, 'pubspec.lock');
    if (File(file).existsSync()) {
      print('$file exists, not generating');
      return;
    }
  }
  if (!await generate(
    dirName: dirName!,
    appName: appName,
    force: force,
    // ignore: deprecated_member_use_from_same_package
    noWeb: noWeb,
  )) {
    return;
  }
  var shell = Shell(workingDirectory: _fixDirName(dirName));
  try {
    await shell.run('git checkout .');
  } catch (e) {
    stderr.writeln('folder not yet in git');
  }
  await shell.run('flutter packages get');
}
