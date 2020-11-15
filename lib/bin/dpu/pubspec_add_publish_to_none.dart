import 'dart:io';

import 'package:tekartik_build_utils/bin/process_run_import.dart';
import 'package:tekartik_build_utils/bin/pubspec_file_content.dart';
import 'package:tekartik_build_utils/common_import.dart';

class AddPublishToNoneCommand extends ShellBinCommand {
  AddPublishToNoneCommand()
      : super(name: 'publish_to_none', description: 'Set publish to none');

  @override
  FutureOr<bool> onRun() async {
    var dirs = results.rest;
    if (dirs.isEmpty) {
      dirs = ['.'];
    }
    await recursiveActions(dirs, verbose: verbose, action: (dir) async {
      var content = PubspecFileContent(join(dir, 'pubspec.yaml'));
      if (await content.read()) {
        // print(content.lines);
        if (content.addPublishToNone()) {
          await content.write();
          stdout.writeln('publish to none added to $dir');
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
  await AddPublishToNoneCommand().parseAndRun(arguments);
}
