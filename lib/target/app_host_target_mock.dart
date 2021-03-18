import 'app_host_target.dart';
export 'app_host_target.dart';

class MockLocationInfo implements LocationInfo {
  @override
  Map<String, String?>? arguments;
  @override
  String? host;
  @override
  String? path;
}
