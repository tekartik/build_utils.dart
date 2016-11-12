import 'package:tekartik_build_utils/grind/grind_app.dart';
export 'package:tekartik_build_utils/grind/grind_app.dart';

main(List<String> args) {
  grind(args);
}

@Task('Test')
test() async {
  devPrint('test');
}
