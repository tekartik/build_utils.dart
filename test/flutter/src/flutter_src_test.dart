@TestOn('vm')
library;

import 'dart:io';

import 'package:tekartik_build_utils/src/flutter/flutter_context.dart';
import 'package:test/test.dart';

class FlutterContextMock with FlutterContextMixin {}

void main() {
  group('flutter_context', () {
    test('mock', () async {
      for (var channel in ['stable', 'beta', 'master']) {
        var context = FlutterContextMock()..channel = channel;
        expect(context.canSupportsWeb, isTrue);
        // Desktop is built on its own host only.
        expect(context.canSupportsMacOS, Platform.isMacOS);
        expect(context.canSupportsLinux, Platform.isLinux);
        expect(context.canSupportsWindows, Platform.isWindows);
      }
    });
  });
}
