import 'package:tekartik_build_utils/shell/shell.dart';

String _gradleExecutableFilename;
String get gradleShellExecutableFilename =>
    _gradleExecutableFilename ??= getBashOrBatExecutableFilename('gradlew');
