import 'dart:io';

import 'package:process_run/cmd_run.dart' show getFlutterVersion;
import 'package:process_run/shell_run.dart';
import 'package:pub_semver/pub_semver.dart';
//import 'package:tekartik_build_utils/common_import.dart';
import 'package:async/async.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
//import 'package:tekartik_build_utils/android/android_import.dart' hide run;

class _Context {
  bool supportsWeb;
  bool supportsMacOS;
  bool supportsLinux;

  final _init = AsyncMemoizer();
  Future<void> init() => _init.runOnce(() async {
        var flutterVersion = await getFlutterVersion();

        var supportsWeb = flutterVersion >= Version(1, 10, 1);
        var supportsMacOS = flutterVersion >= Version(1, 13, 0, pre: 'dev');
        var supportsLinux = flutterVersion >= Version(1, 13, 8, pre: 'pre.39');

        if (supportsWeb) {
          try {
            await run('flutter config --enable-web');
          } catch (e) {
            supportsWeb = false;
            print('supportsWeb: $e');
          }
        }
        this.supportsWeb = supportsWeb;
        if (supportsMacOS) {
          try {
            await run('flutter config --enable-macos-desktop');
          } catch (e) {
            supportsMacOS = false;
            print('supportsMacOS: $e');
          }
        }
        this.supportsMacOS = supportsMacOS;
        if (supportsLinux) {
          try {
            await run('flutter config --enable-linux-desktop');
          } catch (e) {
            supportsLinux = false;
            print('supportsLinux: $e');
          }
        }
        this.supportsLinux = supportsLinux;
      });
}

final _context = _Context();
// Future<_Context>
Future<bool> generate(
    {@required String dirName,
    String appName,
    List<String> options,
    bool force,
    // soon deprecated
    bool noWeb}) async {
  force ??= false;
  appName ??= basename(dirName);
  noWeb ??= false;
  assert(dirName != null && appName != null,
      'invalid dir $dirName or app $appName');
  dirName = _fixDirName(dirName);

  await _context.init();

  var flutterVersion = await getFlutterVersion();

  if ((!noWeb) && (flutterVersion < Version(1, 10, 1))) {
    throw 'invalid flutter version $flutterVersion';
  }
  // var shell = Shell();
  if (!force) {
    print('Create $appName in $dirName. Continue Y/N?');

    var input = stdin.readLineSync();
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
      'flutter create ${options.join(' ')} --project-name $appName $dirName');

  print('continued');
  return true;
}

String _fixDirName(String dirName) => normalize(absolute(dirName));

Future gitGenerate(
    {String dirName,
    String appName,
    bool force,
    // soon deprecated
    bool noWeb}) async {
  force ??= false;
  if (!force) {
    var file = join(dirName, 'pubspec.lock');
    if (File(file).existsSync()) {
      print('$file exists, not generating');
      return;
    }
  }
  if (!await generate(
      dirName: dirName, appName: appName, force: force, noWeb: noWeb)) {
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
