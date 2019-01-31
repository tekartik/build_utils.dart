import 'dart:async';

import 'package:tekartik_build_utils/chrome/chrome.dart';

Future main() async {
  await chromium(noSecurity: true);
}
