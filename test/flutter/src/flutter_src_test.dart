@TestOn('vm')
import 'package:tekartik_build_utils/src/flutter/flutter_context.dart';
import 'package:test/test.dart';

class FlutterContextMock with FlutterContextMixin {}

void main() {
  group('flutter_context', () {
    test('mock', () async {
      var context = FlutterContextMock()..channel = 'beta';
      expect(context.canSupportsWeb, isTrue);
      expect(context.canSupportsMacOS, isFalse);

      context = FlutterContextMock()..channel = 'stable';
      expect(context.canSupportsWeb, isFalse);
      expect(context.canSupportsMacOS, isFalse);
    });
  });
}
