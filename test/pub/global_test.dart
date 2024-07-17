@TestOn('vm')
library;

import 'package:tekartik_build_utils/pub/global.dart';
import 'package:test/test.dart';

void main() {
  group('pub', () {
    group('global', () {
      test('activate', () async {
        await activateIfNeeded('webdev');
        expect(await isActivated('webdev', verbose: false), isTrue);
      });
    });
  });
}
