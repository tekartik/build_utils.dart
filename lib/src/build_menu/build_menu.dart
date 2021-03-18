import 'dart:io';

import 'package:args/args.dart';
import 'package:dev_test/package.dart';
import 'package:tekartik_app_node_build/app_build.dart';
import 'package:tekartik_build_utils/src/build_menu/import.dart';
import 'package:tekartik_test_menu/test_menu.dart';
import 'package:tekartik_test_menu_io/test_menu_io.dart';

export 'package:process_run/shell.dart';

class Project {
  final String dir;
  ShellEnvironment? extraEnvironment;

  static Future<Project> setup(String dir,
      {ShellEnvironment? extraEnvironment}) async {
    if (!Directory(dir).existsSync()) {
      stderr.writeln('Dir $dir does not exist');
      exit(1);
    }
    var project = Project(dir);
    project.extraEnvironment = extraEnvironment;
    stdout.writeln('project: $dir');
    project._pubspecMap = await pathGetPubspecYamlMap(dir);
    stdout.writeln(
        '${project.isFlutter ? 'flutter' : '${project.isNode ? 'node' : 'dart'}'}');

    return project;
  }

  Project(this.dir);

  Map<String, dynamic>? _pubspecMap;

  Map<String, dynamic> get pubspecMap => _pubspecMap!;
  bool? _isFlutter;

  bool? _isNode;

  bool get isNode =>
      _isNode ??= isNodeSupportedSync && pubspecYamlSupportsNode(pubspecMap);

  bool get isFlutter => _isFlutter ??= pubspecYamlSupportsFlutter(pubspecMap);
  Shell? _shell;

  Shell get shell =>
      _shell ??= Shell(workingDirectory: dir, environment: shellEnvironment);
  ShellEnvironment? _shellEnvironment;

  ShellEnvironment get shellEnvironment => _shellEnvironment ??= () {
        var env = ShellEnvironment()
          ..aliases['dof'] = isFlutter ? 'flutter' : 'dart';
        if (extraEnvironment != null) {
          env.merge(extraEnvironment!);
        }
        return env;
      }();
}

void buildMenu(Project project) {
  Future<List<ProcessResult>> run(String command) => project.shell.run(command);

  item('pub get', () async {
    await run('dof pub get');
  });
  item('pub upgrade', () async {
    await run('dof pub upgrade');
  });
  item('pub downgrade', () async {
    await run('dof pub downgrade');
  });
  item('outdated null-safety', () async {
    await run('dof pub outdated --mode=null-safety');
  });
  item('run_ci', () async {
    await packageRunCi(project.dir);
  });
  if (project.isNode) {
    item('[node] run or test check (npm install)', () async {
      await nodeSetupCheck(project.dir);
    });
    item('[node] build', () async {
      await nodeBuild();
    });
    item('[node] build and run', () async {
      await nodeBuildAndRun();
    });
    item('[node] test', () async {
      await nodeRunTest();
    });
  }
}

extension _List<T> on List<T> {
  T? get safeFirst => isEmpty ? null : first;
}

Future<void> main(List<String> arguments) async {
  var parser = ArgParser();
  var result = parser.parse(arguments);
  var dir = result.rest.safeFirst ?? '.';
  var project = await Project.setup(dir);
  mainMenu(arguments, () {
    buildMenu(project);
    /*
    item('build_menu', () async {
      project ??= await Project.setup(dir);
      await showMenu(() => buildMenu(project));
    }, solo: true);

     */
  });
}
