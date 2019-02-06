@TestOn('vm')
import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/pub/global.dart';

void main() {
  group('pub', () {
    group('global', () {
      test('activate', () async {
        await activateIfNeeded('webdev');
        expect(await isActivated('webdev'), isTrue);
      });
    });
  });
}
