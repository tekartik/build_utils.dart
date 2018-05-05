import 'package:tekartik_build_utils/bash/bash.dart';

main() async {
  await bash('''

set -e

node --version
git status
dart --version
gradle --version
pub --version
unzip --help

# adb devices
echo \$PATH
echo \${PWD}
# export
pub get
pub build example/browser
ls -l build

''', verbose: true);
}
