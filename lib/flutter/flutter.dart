import 'package:tekartik_build_utils/shell/shell.dart';

String _flutterExecutableFilename;
String get flutterShellExecutableFilename =>
    _flutterExecutableFilename ??= getBashOrBatExecutableFilename('flutter');
