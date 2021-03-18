import 'package:async/async.dart';
import 'package:process_run/cmd_run.dart' hide run;
import 'package:process_run/shell_run.dart';
import 'package:tekartik_build_utils/flutter/flutter.dart';
import 'package:tekartik_io_utils/io_utils_import.dart';

class FlutterContextImpl with FlutterContextMixin {
  final _init = AsyncMemoizer();

  Future<void> init() => _init.runOnce(() async {
        var flutterVersion = await getFlutterBinVersion();
        channel = await getFlutterBinChannel();
        version = flutterVersion;

        supportsWeb = canSupportsWeb;
        if (canSupportsWeb) {
          try {
            await run('flutter config --enable-web');
          } catch (e) {
            supportsWeb = false;
            print('supportsWeb: $e');
          }
        }
        supportsMacOS = canSupportsMacOS;
        if (canSupportsMacOS) {
          try {
            await run('flutter config --enable-macos-desktop');
          } catch (e) {
            supportsMacOS = false;
            print('supportsMacOS: $e');
          }
        }
        supportsLinux = canSupportsLinux;
        if (canSupportsLinux) {
          try {
            await run('flutter config --enable-linux-desktop');
          } catch (e) {
            supportsLinux = false;
            print('supportsLinux: $e');
          }
        }
        supportsWindows = canSupportsWindows;
        if (canSupportsWindows) {
          try {
            await run('flutter config --enable-windows-desktop');
          } catch (e) {
            supportsWindows = false;
            print('supportsWindows: $e');
          }
        }
      });
}

mixin FlutterContextMixin implements FlutterContext {
  @override
  bool? supportsWeb;
  @override
  bool? supportsMacOS;
  @override
  bool? supportsLinux;
  @override
  bool? supportsWindows;

  @override
  Version? version;

  @override
  String? channel;

  bool get canSupportsWeb => isAtLeastBeta;
  bool get canSupportsMacOS => isAtLeastDev;
  bool get canSupportsLinux => isMaster;
  bool get canSupportsWindows => isMaster;

  @override
  bool get isStable => channel == 'stable';

  @override
  bool get isDev => channel == 'dev';

  @override
  bool get isBeta => channel == 'beta';

  @override
  bool get isMaster => channel == 'master';

  @override
  bool get isAtLeastDev => isAtLeastBeta && !isBeta;

  @override
  bool get isAtLeastBeta => !isStable;
}

final _flutterContextImpl = FlutterContextImpl();

Future<FlutterContextImpl> get flutterContextAsyncImpl async {
  await _flutterContextImpl.init();
  return _flutterContextImpl;
}
