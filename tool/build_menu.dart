import 'package:dev_build/package.dart';
import 'package:process_run/shell.dart';
import 'package:tekartik_test_menu_io/test_menu_io.dart';

//import '

Future main(List<String> arguments) async {
  mainMenu(arguments, () {
    item('run_ci', () async {
      await packageRunCi('.');
    });
    item('quick test', () async {
      await packageRunCi('.', noTest: true);
      await run('dart test test/zip/zip_test.dart');
    });
  });
}
