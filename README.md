# tekartik_build_utils

The legacy Tekartik build toolbox, kept for existing build scripts:

- `runCmd`, a verbose and throwing runner of `ProcessCmd` (process_run), with
  command builders and "is this tool installed" checks for node, npm,
  firebase, gradle, sass, maven, fastlane, travis, chrome, curl, zip;
- `dpu`, a command line utility editing the `pubspec.yaml` of a tree of
  packages (minimum sdk, `publish_to: none`) and opening a per package build
  menu;
- flutter SDK and project helpers (`flutterContext`, `generate`), grinder
  tasks of the old `pub build` web world.

Dart VM only (`dart:io`), Linux, macOS and Windows (`bash()` on Linux and
macOS only). For new code prefer the focused packages: process_run `Shell`,
`tekartik_build_node` (node), `tekartik_android_utils` (adb, apk),
`tekartik_build_flutter` (flutter builds), `dev_build` (`packageRunCi`).

## Getting started

A git dependency (not on pub.dev), a dev dependency:

```yaml
dev_dependencies:
  tekartik_build_utils:
    git:
      url: https://github.com/tekartik/build_utils.dart
```

```dart
// tool/build.dart
import 'package:tekartik_build_utils/common_import.dart';

Future<void> main() async {
  // Prints the command, throws on a non zero exit code.
  await runCmd(DartCmd(['--version']));
  if (isNodeSupported) {
    await runCmd(NodeCmd(['--version']), verbose: false);
  }
}
```

## dpu

```shell
dart pub global activate -s git https://github.com/tekartik/build_utils.dart
dpu --help
```

| Command | Does |
| --- | --- |
| `dpu update_min_sdk [<dir>...]` | sets the lower bound of `environment: sdk:` to `TEKARTIK_DART_SDK_MIN` in every package found |
| `dpu publish_to_none [<dir>...]` | adds `publish_to: none` where it is missing |
| `dpu build_menu [<dir>]` | an interactive menu: pub get/upgrade/downgrade, `run_ci`, node items |
| `dpu create_local_dpu [<dir>...]` | writes `.local/version_info.dart` and `.local/build_menu.dart` in each package |

The pubspec edits are line based (comments kept): run them on a clean git
tree and review the diff.

## Pitfalls

- `runCmd` is verbose by default and throws on a non zero exit code.
- The node items of `dpu build_menu <dir>` (build, build and run, test) act on
  the current directory, not on `<dir>`: run it from the package.
- `flutterContext` runs `flutter config --enable-web` (and the desktop of the
  host) on first use, writing the user flutter configuration.
- `generate` and `gitGenerate(force: true)` delete the target folder before
  `flutter create` (`gitGenerate` then restores the tracked files with `git
  checkout .`: uncommitted changes there are lost).
- A local `dart test` of this package runs `test/flutter/`: it clones and
  installs a Flutter SDK in `.dart_tool` and creates and builds flutter
  projects (minutes, gigabytes); run the other folders on their own.

The agent skills of this package: `skills/tekartik-build-utils-cmd-run` and
`skills/tekartik-build-utils-dpu`.
