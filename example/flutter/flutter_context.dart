import 'package:tekartik_build_utils/flutter/flutter.dart';

Future main() async {
  var context = await flutterContext;
  print('supportsWeb: ${context.supportsWeb}');
  print('supportsMacOS: ${context.supportsMacOS}');
  print('supportsLinuxs: ${context.supportsLinux}');
  print('supportsWindows: ${context.supportsWindows}');
}
