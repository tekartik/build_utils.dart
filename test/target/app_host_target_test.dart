// Copyright (c) 2016, Alexandre Roux Tekartik. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:dev_test/test.dart';
import 'package:tekartik_build_utils/target/app_host_target.dart';
import 'package:tekartik_build_utils/target/app_host_target_mock.dart';

void main() {
  group('app_host_target', () {
    test('fromTargetName', () {
      expect(
          identical(AppHostTarget.fromTargetName("local"), AppHostTarget.local),
          isTrue);
      expect(AppHostTarget.fromTargetName("dev"), AppHostTarget.dev);
      expect(AppHostTarget.fromTargetName("staging"), AppHostTarget.staging);
      expect(AppHostTarget.fromTargetName("prod"), AppHostTarget.prod);
      expect(AppHostTarget.fromTargetName("dummy"), isNull);
      expect(AppHostTarget.fromTargetName(null), isNull);
    });

    test('fromPath', () {
      expect(AppHostTarget.fromPath("-local"), isNull);
      expect(AppHostTarget.fromPath("-dev/"), AppHostTarget.dev);
      expect(AppHostTarget.fromPath("-staging/"), AppHostTarget.staging);
      expect(AppHostTarget.fromPath("-prod/"), isNull);
      expect(AppHostTarget.fromPath(null), isNull);
    });

    test('fromHost', () {
      expect(AppHostTarget.fromHost("localhost"), AppHostTarget.local);
      expect(AppHostTarget.fromHost("-dev."), AppHostTarget.dev);
      expect(AppHostTarget.fromHost("-staging."), AppHostTarget.staging);
      expect(AppHostTarget.fromHost("-prod."), isNull);
      expect(AppHostTarget.fromHost(null), isNull);
    });

    test('fromArguments', () {
      expect(AppHostTarget.fromArguments(null), isNull);
      expect(AppHostTarget.fromArguments({}), isNull);
      expect(AppHostTarget.fromArguments({'dev': null}), AppHostTarget.dev);
      expect(AppHostTarget.fromArguments({'local': ""}), AppHostTarget.local);
      expect(AppHostTarget.fromArguments({'staging': "false"}),
          AppHostTarget.staging);
      expect(AppHostTarget.fromArguments({'prod': null}), AppHostTarget.prod);
      expect(AppHostTarget.fromArguments({'dummy': null}), isNull);
    });

    test('fromLocation', () {
      MockLocationInfo locationInfo = new MockLocationInfo();
      expect(AppHostTarget.fromLocationInfo(null), isNull);
      expect(AppHostTarget.fromLocationInfo(locationInfo), isNull);
      locationInfo.path = "blah-dev/";
      expect(AppHostTarget.fromLocationInfo(locationInfo), AppHostTarget.dev);
      locationInfo.host = "blah-staging.";
      expect(
          AppHostTarget.fromLocationInfo(locationInfo), AppHostTarget.staging);
      locationInfo.arguments = {'prod': null};
      expect(AppHostTarget.fromLocationInfo(locationInfo), AppHostTarget.prod);

      /*
      expect(
          identical(AppHostTarget.fromHost("localhost"), AppHostTarget.local),
          isTrue);
      expect(AppHostTarget.fromHost("-dev."), AppHostTarget.dev);
      expect(AppHostTarget.fromHost("-staging."), AppHostTarget.staging);
      expect(AppHostTarget.fromHost("-prod."), isNull);
      */
    });

    test('locationSearchGetArguments', () {
      Map<String, String> params;

      params = locationSearchGetArguments("?t=1");
      expect(params.length, equals(1));
      expect(params['t'], equals("1"));
      expect(params['y'], isNull);

      params = locationSearchGetArguments("t=1");
      expect(params.length, equals(1));
      expect(params['t'], equals("1"));
      expect(params['y'], isNull);

      params = locationSearchGetArguments("/fulluri/yeap?t=1");
      expect(params.length, equals(1));
      expect(params['t'], equals("1"));
      expect(params['y'], isNull);

      expect(locationSearchGetArguments('?tata&log=info&tutu=1')['tutu'],
          equals('1'));
      expect(locationSearchGetArguments('?tata&log=info&tutu=1')['tata'],
          equals(''));
      expect(locationSearchGetArguments('tata&log=info&tutu=1')['tata'],
          equals(''));
      expect(locationSearchGetArguments('tata&log=info&tutu=1')['tata'],
          equals(''));
      expect(locationSearchGetArguments(null).isEmpty, isTrue);

      // Handle decoding
      String search =
          'state=%7B"ids":%5B"0B4xfXXDGtr7XbGZvaGZadlAtb1U"%5D,"action":"open","userId":"106049382465267012344"%7D';
      //Map map = Uri.splitQueryString(search); // this fails as it does not handle the ?
      Map map = locationSearchGetArguments(search);
      //print(map['state']);
      expect(map['state'].startsWith('{"ids":["0B4x'), isTrue);
      //String uri = 'http://milomedy.tekartik.com/?state=%7B%22ids%22:%5B%220B4xfXXDGtr7XbGZvaGZadlAtb1U%22%5D,%22action%22:%22open%22,%22userId%22:%22106049382465267012344%22%7D';
      //Uri.parse(uri)
    });
  });
}
