import 'package:tekartik_build_utils/common_import.dart';
import 'package:tekartik_build_utils/src/flutter/flutter_context.dart';
import 'package:tekartik_sc/git.dart';

String? _flutterExecutableFilename;

String get flutterShellExecutableFilename =>
    _flutterExecutableFilename ??= getBashOrBatExecutableFilename('flutter');

/// Install flutter at the given path
Future installFlutter(String path) async {
  await downloadFlutter(path);
  var flutterExecutable = executableInPathSync('flutter', join(path, 'bin'));
  await runCmd(ProcessCmd(flutterExecutable, ['doctor']));
}

Future downloadFlutter(String path, {String? branch}) async {
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

abstract class FlutterContext {
  bool? get supportsWeb;

  bool? get supportsMacOS;

  bool? get supportsLinux;

  bool? get supportsWindows;

  Version? get version;

  String? get channel;

  bool get isStable;

  bool get isDev;

  bool get isBeta;

  bool get isMaster;

  bool get isAtLeastDev;

  bool get isAtLeastBeta;
}

/// our flutter context
Future<FlutterContext> get flutterContext => flutterContextAsyncImpl;
