import '../common_import.dart';

class Project {
  String path;

  Project([this.path]);

  ProcessCmd cmd(ProcessCmd processCmd) {
    return processCmd..workingDirectory = path;
  }
}
