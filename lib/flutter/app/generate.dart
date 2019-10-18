import 'package:process_run/shell.dart';
import 'package:tekartik_build_utils/common_import.dart';

Future<bool> generate(
    {@required String dirName, String appName, bool force, bool noWeb}) async {
  force ??= false;
  appName ??= dirName;
  noWeb ??= false;
  assert(dirName != null && appName != null,
      'invalid dir $dirName or app $appName');
  dirName = _fixDirName(dirName);
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
  var shell = Shell(workingDirectory: dirname(dirName));
  if (!noWeb) {
    await shell.run('flutter config --enable-web');
    await shell.run('flutter create --web --project-name $appName $dirName');
  } else {
    await shell.run('flutter create --project-name $appName $dirName');
  }

  print('continued');
  return true;
}

String _fixDirName(String dirName) => normalize(absolute(dirName));

Future gitGenerate(
    {String dirName, String appName, bool force, bool noWeb}) async {
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
  await shell.run('''
git checkout .
flutter packages get
''');
}
