import 'package:tekartik_common_utils/string_enum.dart';

//Version appVersion = new Version(0, 1, 0);

bool _isLocalhost(String host) {
  return host.contains('localhost');
}

bool _isHostStaging(String host) {
  return host.contains('-staging.');
}

bool _isHostDev(String host) {
  return host.contains('-dev.');
}

bool _isPathStaging(String path) {
  return path.contains('-staging/');
}

bool _isPathDev(String path) {
  return path.contains('-dev/');
}

class AppHostTarget extends StringEnum {
  AppHostTarget(String name) : super(name);
  static final AppHostTarget local = AppHostTarget("local");
  static final AppHostTarget dev = AppHostTarget("dev");
  static final AppHostTarget staging = AppHostTarget("staging");
  static final AppHostTarget prod = AppHostTarget("prod");
  static List<AppHostTarget> all = [local, dev, staging, prod];

  static AppHostTarget fromTargetName(String targetName) {
    if (targetName != null) {
      AppHostTarget tmpTarget = AppHostTarget(targetName);
      for (AppHostTarget target in all) {
        if (tmpTarget == target) {
          return target;
        }
      }
    }
    return null;
  }

  // will never return prod
  static AppHostTarget fromHost(String host) {
    if (host != null) {
      if (_isLocalhost(host)) {
        return local;
      }

      if (_isHostDev(host)) {
        return dev;
      }

      if (_isHostStaging(host)) {
        return staging;
      }
    }
    return null;
  }

  // will never return prod nor local
  static AppHostTarget fromPath(String path) {
    if (path != null) {
      if (_isPathStaging(path)) {
        return staging;
      }

      if (_isPathDev(path)) {
        return dev;
      }
    }

    return null;
  }

  static AppHostTarget fromArguments(Map<String, String> arguments) {
    if (arguments != null && arguments.isNotEmpty) {
      for (AppHostTarget target in all) {
        if (arguments.containsKey(target.name)) {
          return target;
        }
      }
    }
    return null;
  }

  // Allow to check with arguments first
  static AppHostTarget fromHostAndPath(String host, String path) {
    AppHostTarget target = fromHost(host);
    target ??= fromPath(path);
    return target;
  }

  static AppHostTarget fromLocationInfo(LocationInfo locationInfo) {
    if (locationInfo != null) {
      AppHostTarget target = fromArguments(locationInfo.arguments);
      target ??= fromHostAndPath(locationInfo.host, locationInfo.path);
      return target;
    }
    return null;
  }
}

abstract class LocationInfo {
  String get host;

  String get path;

  Map<String, String> get arguments;
}

/// Typically [search] is window.location.search
Map<String, String> locationSearchGetArguments(String search) {
  Map<String, String> params = {};
  if (search != null) {
    int questionMarkIndex = search.indexOf('?');
    if (questionMarkIndex != -1) {
      search = search.substring(questionMarkIndex + 1);
    }
    return Uri.splitQueryString(search);
  }
  return params;
}
