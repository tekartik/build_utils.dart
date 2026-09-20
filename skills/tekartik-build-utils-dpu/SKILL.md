---
name: tekartik-build-utils-dpu
description: >-
  Use when batch-editing pubspec.yaml files or running the dpu dart project
  utility of tekartik_build_utils: the dpu command (update_min_sdk,
  publish_to_none, build_menu, create_local_dpu), PubspecFileContent with
  updateDartSdk and addPublishToNone, UpdateMainSdkCommand,
  AddPublishToNoneCommand, BuildMenuCommand, CreateLocalDpuCommand,
  MainShellCommand, dpuBinVersion and the recursiveActions helper over a tree
  of Dart packages.
---

# dpu: dart project utility (tekartik_build_utils)

`dpu` is the CLI shipped by `tekartik_build_utils`: it walks a tree of Dart
packages and edits their `pubspec.yaml` (minimum sdk, `publish_to: none`),
opens a per-project build menu, or drops local helper scripts. The same work
is available as a small API (`PubspecFileContent`) for custom scripts.

## Guidelines

* Install the CLI (the package is not on pub.dev, single-package repo so no
  `path:`):
  ```yaml
  dev_dependencies:
    tekartik_build_utils:
      git:
        url: https://github.com/tekartik/build_utils.dart
      version: '>=0.7.9'
  ```
  then `dart run tekartik_build_utils:dpu <command>`, or activate it globally
  with `dart pub global activate -sgit
  https://github.com/tekartik/build_utils.dart` (or `-s path .` from a
  checkout) and call `dpu` directly.
* Commands (`dpu --help`, `dpu --version`, `-v` for verbose):
  * `dpu update_min_sdk [<dir>...]` — rewrites the `environment: sdk:`
    constraint of every package found under the directories (default `.`),
    keeping the upper bound. The target version comes from the
    `TEKARTIK_DART_SDK_MIN` environment variable; without it the command
    prints an error and exits with code 1.
  * `dpu publish_to_none [<dir>...]` — inserts `publish_to: none` after the
    `name`/`description`/`version`/`homepage`/`author` header of every
    `pubspec.yaml` that does not have it yet.
  * `dpu build_menu [<dir>]` — interactive menu for one package: pub
    get/upgrade/downgrade, `outdated --mode=null-safety`, `run_ci`
    (`dev_build`'s `packageRunCi`) and, for a node package, npm setup, node
    build, build and run, and test.
  * `dpu create_local_dpu [<dir>...]` — writes `.local/version_info.dart`
    (prints the dart/flutter versions and channels) and `.local/build_menu.dart`
    (runs `dpu build_menu`) in each package; it throws a `StateError` when a
    directory is not a Dart package root.
* Both pubspec commands are **line-based edits**: comments and formatting are
  preserved, but the file must have a conventional layout. They are recursive
  over Dart packages (`node_modules`, hidden and build folders are skipped)
  and print one line per package (`Updated <dir>` / `Not updated <dir>`).
  Run them on a clean git tree and review the diff.
* API for custom scripts: `package:tekartik_build_utils/bin/
  pubspec_file_content.dart` gives `PubspecFileContent(path)` with
  `Future<bool> read()` (false and a stderr message when unreadable),
  `bool updateDartSdk({required Version minVersion})`,
  `bool addPublishToNone()` (both return whether something changed, and only
  mutate the in-memory `lines`), and `Future<void> write()`.
  `PubspecFileContent.inMemory()` builds one without a file (set `lines`
  yourself). `Version` comes from `common_import.dart`.
* To walk the packages the same way `dpu` does, use `recursiveActions(paths,
  action: (dir) async {...}, verbose: ...)`, re-exported by
  `package:tekartik_build_utils/bin/process_run_import.dart` (it also
  re-exports `ShellBinCommand`, `FileContent` and the `dev_build` package
  helpers such as `isPubPackageRoot` and `pathGetPubspecYamlMap`).
* Each command is a public `ShellBinCommand` subclass that can be reused in
  another CLI: `UpdateMainSdkCommand` (`bin/dpu/pubspec_update_min_sdk.dart`),
  `AddPublishToNoneCommand` (`bin/dpu/pubspec_add_publish_to_none.dart`),
  `BuildMenuCommand` (`bin/dpu/build_menu_command.dart`),
  `CreateLocalDpuCommand` (`bin/dpu/create_local_dpu.dart`), all aggregated by
  `MainShellCommand`/`mainCommand` in `bin/dart_project_util.dart` (which also
  exposes `dpuBinVersion` and a `main(arguments)`). Add them to your own
  `ShellBinCommand` with `addCommand(...)`, or call
  `<Command>().parseAndRun(arguments)`.
* `dpu build_menu` is interactive (it reads stdin and ends with
  `promptTerminate()`); do not use it in CI, use `packageRunCi` directly.

## Examples

### Bump the minimum sdk of every package of a repository

```dart
import 'package:tekartik_build_utils/bin/process_run_import.dart';
import 'package:tekartik_build_utils/bin/pubspec_file_content.dart';
import 'package:tekartik_build_utils/common_import.dart';

Future<void> main(List<String> args) async {
  var minVersion = Version.parse('3.12.0');
  await recursiveActions(
    args.isEmpty ? ['.'] : args,
    action: (dir) async {
      var content = PubspecFileContent(join(dir, 'pubspec.yaml'));
      if (await content.read() &&
          content.updateDartSdk(minVersion: minVersion)) {
        await content.write();
        stdout.writeln('updated $dir');
      }
    },
  );
}
```

### Make one package unpublishable

```dart
import 'dart:io';

import 'package:tekartik_build_utils/bin/pubspec_file_content.dart';

Future<void> main() async {
  var content = PubspecFileContent('pubspec.yaml');
  if (await content.read() && content.addPublishToNone()) {
    await content.write();
    stdout.writeln('publish_to: none added');
  }
}
```

### Run a single dpu command from a script

```dart
import 'package:tekartik_build_utils/bin/dpu/pubspec_add_publish_to_none.dart';

Future<void> main(List<String> arguments) async {
  // Same as `dpu publish_to_none <args>`
  await AddPublishToNoneCommand().parseAndRun(arguments);
}
```

### Embed the whole dpu command tree in another CLI

```dart
import 'package:tekartik_build_utils/bin/dart_project_util.dart' as dpu;

Future<void> main(List<String> arguments) async {
  // `--version` prints dpu.dpuBinVersion
  await dpu.main(arguments);
}
```

## Common mistakes

* Running `dpu update_min_sdk` without `TEKARTIK_DART_SDK_MIN` set: it exits
  with an error.
* Forgetting that `updateDartSdk`/`addPublishToNone` only change the in-memory
  lines: nothing is saved until `write()`.
* Expecting a yaml-aware rewrite: the edit is line-based and gives up
  (returning `false`, logging `environment not found`) on an unusual layout.
* Using `dpu build_menu` in a non-interactive script.
