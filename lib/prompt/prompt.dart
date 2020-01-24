import 'package:tekartik_build_utils/common_import.dart';

Future<bool> confirm(String text) async {
  print('$text. Continue Y/N?');

  var input = stdin.readLineSync();
  if (input.toLowerCase() != 'y') {
    return false;
  }
  return true;
}
