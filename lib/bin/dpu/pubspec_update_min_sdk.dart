import 'package:process_run/shell.dart';
import 'package:tekartik_build_utils/bin/process_run_import.dart';
import 'package:tekartik_build_utils/bin/pubspec_file_content.dart';
import 'package:tekartik_build_utils/common_import.dart';

class UpdateMainSdkCommand extends ShellBinCommand {
  UpdateMainSdkCommand()
      : super(name: 'update_min_sdk', description: 'Update min sdk');

  @override
  FutureOr<bool> onRun() async {
    var minSdk = shellEnvironment['TEKARTIK_DART_SDK_MIN'];
    if (minSdk == null) {
      stderr.writeln(
          'define TEKARTIK_DART_SDK_MIN. ds env var set TEKARTIK_DART_SDK_MIN xxx');
      exit(1);
    }
    var dirs = results.rest;
    if (dirs.isEmpty) {
      dirs = ['.'];
    }
    print('Updating to min dart sdk to $minSdk');
    await recursiveActions(dirs, verbose: verbose, action: (dir) async {
      var content = PubspecFileContent(join(dir, 'pubspec.yaml'));
      if (await content.read()) {
        // print(content.lines);
        if (content.updateDartSdk(minVersion: Version.parse(minSdk))) {
          await content.write();
          stdout.writeln('Updated $dir');
        } else {
          stdout.writeln('Not updated $dir');
        }
      } else {
        stderr.writeln('cannot read $content');
      }
    });
    return true;
  }
}

/// Direct shell env Alias dump run helper for testing.
Future<void> main(List<String> arguments) async {
  await UpdateMainSdkCommand().parseAndRun(arguments);
}
