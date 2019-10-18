import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

/// W3C deprecated AppCache

const _deployExcludeKey = 'exclude';
const appCacheExcludeKey = 'appcache_exclude';

List<String> settingsGetExcluded(Map map) =>
    settingsGetStringList(map, _deployExcludeKey);
List<String> settingsGetAppCacheExcluded(Map map) =>
    settingsGetStringList(map, appCacheExcludeKey);

List<String> settingsGetStringList(Map map, String key) {
  if (map != null) {
    var items = map[key];
    if (items is List) {
      return <String>[]
        ..addAll(items.where((item) => item != null).map((item) => '$item'));
    }
  }
  return null;
}

Map settingsAddExcluded(Map map, List<String> excluded) {
  if (excluded?.isNotEmpty == true) {
    var list = List<String>.from(settingsGetExcluded(map) ?? <String>[]);
    map = Map.from(map ?? {});
    map[_deployExcludeKey] = list..addAll(excluded);
  }
  return map;
}

/// Fix appcache settings adding specific
Future<Map> fixAppCacheSettings(Map settings, {File yaml}) async {
  if (settings == null) {
    if (yaml != null) {
      String content = await yaml.readAsString();
      settings = loadYaml(content) as Map;
    }
    settings ??= {};
  }

  // Add specific app cache excludes
  var appCacheExcluded = settingsGetAppCacheExcluded(settings);
  if (appCacheExcluded?.isNotEmpty == true) {
    settings = settingsAddExcluded(settings, appCacheExcluded);
    settings.remove(appCacheExcludeKey);
  }

  return settings;
}

String appCacheFromTemplate(String template, List<String> paths) {
  return appCacheLinesFromTemplate(template, paths).join('\n');
}

List<String> appCacheLinesFromTemplate(String template, List<String> paths) {
  var output = <String>[];
  var appCache = template;
  Iterable<String> lines = LineSplitter.split(appCache);
  bool replace = false;

  for (String line in lines) {
    if (line == "# end") {
      assert(replace == true);
      replace = false;
    } else if (line == "# start") {
      assert(replace == false);
      replace = true;
      // keep start
      output.add(line);
      output.addAll(paths);
    }
    if (!replace) {
      output.add(line);
    }
  }

  //print(appCache);
  //print(output);
  return output;
}
