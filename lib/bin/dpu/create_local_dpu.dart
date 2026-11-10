import 'package:tekartik_build_utils/bin/process_run_import.dart';
import 'package:tekartik_build_utils/common_import.dart';

class CreateLocalDpuCommand extends ShellBinCommand {
  CreateLocalDpuCommand()
    : super(
        name: 'create_local_dpu',
        description: 'Create local project util script',
      );

  @override
  FutureOr<bool> onRun() async {
    var dirs = results.rest;
    if (dirs.isEmpty) {
      dirs = ['.'];
    }
    for (var dir in dirs) {
      if (!await isPubPackageRoot(dir)) {
        throw StateError('$dir not a dart project');
      }
      // In the package, not in the current directory.
      var localDir = join(dir, '.local');
      await Directory(localDir).create(recursive: true);
      var file = File(join(localDir, 'version_info.dart'));

      // ignore: avoid_print
      print('Creating $file');
      //if (pubspecYamlSupportsFlutter(map) && await isFlutterSupported) {
      await file.writeAsString(r'''
// ignore_for_file: avoid_print
import 'package:process_run/shell.dart';

Future<void> main() async {
  if (await isFlutterSupported) {
    print(
      'Flutter: ${await getFlutterBinVersion()} (${await getFlutterBinChannel()})',
    );
  }
  print('   Dart: $dartVersion ($dartChannel)');
}
''');

      file = File(join(localDir, 'build_menu.dart'));

      // ignore: avoid_print
      print('Creating $file');

      await file.writeAsString(r'''
import 'package:process_run/shell.dart';

Future<void> main() async {
  var shell = Shell(stdin: sharedStdIn);
  await shell.run('dpu build_menu');
  await sharedStdIn.terminate();
}
''');
    }
    return true;
  }
}

/// Direct shell env Alias dump run helper for testing.
Future<void> main(List<String> arguments) async {
  await CreateLocalDpuCommand().parseAndRun(arguments);
}
