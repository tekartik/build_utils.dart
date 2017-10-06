import 'cmd_run.dart';

ProcessCmd zipCmd(String zipFile, {String dir}) {
  return processCmd("zip", ["-r", zipFile, dir]);
}
