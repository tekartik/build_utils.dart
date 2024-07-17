import 'package:tekartik_build_utils/net/net.dart';
import 'package:test/test.dart';

void main() {
  group('net', () {
    test('get_lan_localhost', () async {
      expect(await getLanLocalhost(), isNotEmpty);
    });
  });
}
