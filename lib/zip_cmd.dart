import 'cmd_run.dart';

ProcessCmd zipCmd(String zipFile, {String? dir}) {
  return ProcessCmd('zip', ['-r', zipFile, dir!]);
}
