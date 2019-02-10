import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:tekartik_build_utils/cmd_run.dart';
import 'package:tekartik_build_utils/shell/shell.dart';
import 'package:tekartik_sc/git.dart';

String _flutterExecutableFilename;

String get flutterShellExecutableFilename =>
    _flutterExecutableFilename ??= getBashOrBatExecutableFilename('flutter');

/// Install flutter at the given path
Future installFlutter(String path) async {
  await downloadFlutter(path);
  var flutterExecutable = executableInPathSync('flutter', join(path, 'bin'));
  await runCmd(ProcessCmd(flutterExecutable, ['doctor']));
}

Future downloadFlutter(String path, {String branch}) async {
  branch ??= 'stable';
  await Directory(dirname(path)).create(recursive: true);
  try {
    await runCmd(gitCmd([
      'clone',
      'git://github.com/flutter/flutter.git',
      '--branch',
      branch,
      '--depth',
      '1',
      basename(path)
    ])
      ..workingDirectory = dirname(path));
  } catch (e) {
    try {
      // Failing, try to pull only
      await runCmd(gitCmd(['pull'])..workingDirectory = path);
    } catch (_) {
      throw e;
    }
  }
}
