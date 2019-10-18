import 'package:tekartik_build_utils/src/appcache/appcache_impl.dart';
import 'package:test/test.dart';

void main() {
  group('appcache', () {
    test('exclude', () {
      var map = settingsAddExcluded(null, ['test']);
      expect(map, {
        'exclude': ['test']
      });
      map = settingsAddExcluded(map, ['test2']);
      expect(map, {
        'exclude': ['test', 'test2']
      });
    });

    test('fix_settings', () async {
      var map = await fixAppCacheSettings({
        'appcache_exclude': ['x']
      });
      expect(map, {
        'exclude': ['x']
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
