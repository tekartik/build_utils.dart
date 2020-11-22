import 'package:tekartik_build_utils/bin/process_run_import.dart';
import 'package:tekartik_build_utils/src/build_menu/build_menu.dart';
import 'package:tekartik_test_menu_io/test_menu_io.dart';

class BuildMenuCommand extends ShellBinCommand {
  BuildMenuCommand() : super(name: 'build_menu', description: 'Build menu');

  @override
  FutureOr<bool> onRun() async {
    List<String> arguments;
    String dir;
    if (results.rest.isEmpty) {
      arguments = [];
      dir = '.';
    } else {
      arguments = results.rest.sublist(1);
      dir = results.rest.first;
    }
    // ignore: unnecessary_statements
    arguments;

    var project = await Project.setup(dir);

    initTestMenuConsole(results.rest);
    await showMenu(() {
      buildMenu(project);
    });
    return true;
  }
}

/// Direct shell env Alias dump run helper for testing.
Future<void> main(List<String> arguments) async {
  await BuildMenuCommand().parseAndRun(arguments);
}
