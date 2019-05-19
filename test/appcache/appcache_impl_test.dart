import 'package:tekartik_build_utils/src/appcache/appcache_impl.dart';
import 'package:test/test.dart';

void main() {
  group('appcache', () {
    test('excluded', () {
      var map = settingsAddExcluded(null, ['test']);
      expect(map, {
        'excluded': ['test']
      });
      map = settingsAddExcluded(map, ['test2']);
      expect(map, {
        'excluded': ['test', 'test2']
      });
    });

    test('fix_settings', () async {
      var map = await fixAppCacheSettings({
        'appcache_excluded': ['x']
      });
      expect(map, {
        'excluded': ['x']
      });
    });

    test('appCacheFromTemplate', () {
      var output = appCacheFromTemplate('''
before
# start
test5
# end
after''', ['test1', 'test2']);
      expect(output, '''
before
# start
test1
test2
# end
after''');
    });
  });
}
