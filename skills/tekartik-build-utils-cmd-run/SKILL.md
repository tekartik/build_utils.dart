---
name: tekartik-build-utils-cmd-run
description: >-
  Use when a Dart build script must run external build tools with
  tekartik_build_utils: the common_import.dart umbrella import, runCmd (verbose
  and throwing), ProcessCmd/PubCmd/NodeCmd/NpmCmd/FirebaseCmd/grindCmd/zipCmd/
  curlCmd, firebaseArgs, isNodeSupported, isNpmSupported,
  isFirebaseSupportedSync, isTravisSupportedSync, isFastlaneSupportedSync,
  checkSassSupported, checkMavenSupported, getBashOrBatExecutableFilename,
  getBashOrCmdExecutableFilename, executableInPathSync, bash(),
  activateIfNeeded, zip/unzip, getLanLocalhost, confirm, installFlutter and
  flutterContext.
---

# Running external build tools (tekartik_build_utils)

`tekartik_build_utils` is the legacy Tekartik build toolbox: a thin, throwing,
verbose `runCmd` on top of `package:process_run`, plus per-tool command
builders and "is this tool installed" checks (node, npm, firebase, gradle,
sass, maven, fastlane, travis, flutter, chrome, curl, zip).

## Guidelines

* Dev-time tool, not on pub.dev, single-package repo (no `path:` in the git
  block):
  ```yaml
  dev_dependencies:
    tekartik_build_utils:
      git:
        url: https://github.com/tekartik/build_utils.dart
      version: '>=0.7.9'
  ```
  It can also be activated as a CLI: `dart pub global activate -sgit
  https://github.com/tekartik/build_utils.dart` (see the
  [../tekartik-build-utils-dpu/SKILL.md](../tekartik-build-utils-dpu/SKILL.md)
  skill for the `dpu` command).
* This is an old package kept for existing build scripts. For new code prefer
  the focused packages when they cover the need: `tekartik_build_node` for
  node/npm builds, `tekartik_android_utils` for adb/apk (the `android/
  android_cmd.dart` library here is `@Deprecated`), `tekartik_app_io_zip` for
  zip/unzip (`zip/zip.dart` just forwards to it), `dev_build` for
  `packageRunCi`, `tekartik_build_flutter` for flutter app builds.
* `package:tekartik_build_utils/common_import.dart` is the umbrella import of
  a build script: it re-exports `dart:io` (via `tekartik_io_utils`, hiding
  `sleep` and `ProcessException`), `package:path` (hiding `Context`),
  `tekartik_common_utils` (`Version`, `jsonPretty`...), `tekartik_deploy`'s
  `fsDeploy`, `tekartik_pub`'s `PubPackage`, and this package's `cmd_run.dart`
  (hence `ProcessCmd`, `PubCmd`, `DartCmd`, `PbrCmd`, `WebDevCmd`,
  `FlutterCmd` from `process_run`), `firebase/firebase_cmd.dart`,
  `grind/grind_cmd.dart`, `node/node_cmd.dart` and `project/project.dart`.
  Import the tool-specific library on top when needed
  (`firebase/firebase.dart`, `sass/sass.dart`, `flutter/flutter.dart`...).
* `runCmd(ProcessCmd cmd, {bool? verbose, bool? commandVerbose, stdin, stdout,
  stderr})` replaces `process_run`'s own `runCmd` (it is hidden by the export):
  * `verbose` defaults to **true** (pass `verbose: false` to silence),
  * it prints `$ dir: [<workingDirectory>]` when the command has one,
  * it throws `Exception('Exit code <n> running <cmd>')` on a non-zero exit,
  * a missing executable is reported (`Cannot find command ...`) and the
    original error is rethrown.
  So a build script fails loudly by default; wrap the call in `try`/`catch`
  only when the failure is expected (probing a tool).
* Build a command with `ProcessCmd(executable, args, workingDirectory: dir)`
  (`workingDirectory` is also settable afterwards, which is what
  `Project(path).cmd(processCmd)` does), or with the ready-made subclasses:
  `NodeCmd(args)`, `NpmCmd(args)`, `FirebaseCmd(args)`, `grindCmd(args)`
  (a `PubCmd` running `grinder:grinder`), `zipCmd(zipFile, dir: dir)`,
  `curlCmd(args)`, `MavenProject(path).cmd(mvnArgs([...]))`, and
  `PubCmd`/`DartCmd`/`PbrCmd`/`WebDevCmd` from `process_run`.
* Tool detection, all cached after the first call: `isNodeSupported`,
  `isNpmSupported` (sync, `which`-based), `isFirebaseSupportedSync`,
  `isTravisSupportedSync`, `isFastlaneSupportedSync` (sync, they run
  `<tool> --version`), plus the async `checkSassSupported()`,
  `checkMavenSupported()`, `getFastlaneVersion()` and `runningInTravis`
  (the `TRAVIS` env var). Guard optional steps with them instead of catching
  the `runCmd` failure.
* Windows executable names: `getBashOrBatExecutableFilename('gradle')` →
  `gradle.bat`, `getBashOrCmdExecutableFilename('npm')` → `npm.cmd` (and the
  plain name elsewhere); `gradleShellExecutableFilename`,
  `flutterShellExecutableFilename`, `firebaseExecutableName`,
  `travisExecutableName`, `fastlaneExecutableName` already apply them.
  `executableInPathSync(executable, path)` finds an executable in a folder.
* `firebaseArgs({deploy, serve, onlyFunctions, onlyHosting, projectId})` builds
  the argument list for `FirebaseCmd` (it throws an `ArgumentError` when both
  `deploy` and `serve` are true).
* `bash(String commands, {required bool verbose, String? workingDirectory})`
  writes the script to a temp file, prepends the Dart bin directory to `PATH`
  and runs it with `bash`, throwing on a non-zero exit. Linux/macOS only.
* pub global: `isActivated(packageName, {verbose})` and
  `activateIfNeeded(packageName)`; `webdevActivate()` then
  `serve(['web'])` (from `webdev/webdev.dart`) for a webdev server.
* Misc helpers: `zip(directoryPath, {dst})` / `unzip(zipFilePath, {dst})`,
  `getLanLocalhost()` (the LAN ipv4, `localhost` as a fallback),
  `confirm('text')` (blocking Y/N prompt on stdin),
  `chrome({noSecurity, userDataDir})` / `chromium(...)`,
  `fixAppCache(yaml: File(...))` for the legacy appcache manifest.
* Flutter SDK management (not app builds): `downloadFlutter(path, {branch})`
  (shallow git clone of the `stable` branch by default), `installFlutter(path)`
  (download + `flutter doctor`), and `await flutterContext` returning a
  `FlutterContext` (`version`, `channel`, `isStable`, `isBeta`, `isDev`,
  `isMaster`, `isAtLeastBeta`, `isAtLeastDev`, `supportsWeb`, `supportsLinux`,
  `supportsMacOS`, `supportsWindows`).
* `grind/grind_app.dart` exposes grinder `@Task`s and the legacy `App` helper
  (`pub build`/`build_runner`, `fsdeploy`, `fbdeploy`, `gswebdeploy`,
  appcache). It targets the old `pub build`/appcache web world — do not start
  new projects on it.

## Examples

### Run dart/pub commands, failing the script on error

```dart
import 'package:tekartik_build_utils/common_import.dart';

Future<void> main() async {
  await runCmd(PubCmd(['get']));
  await runCmd(DartCmd(['analyze', 'lib']), verbose: false);
  // Any non-zero exit code throws.
  await runCmd(ProcessCmd('echo', ['done'], workingDirectory: '.'));
}
```

### Deploy to firebase hosting when the CLI is installed

```dart
import 'package:tekartik_build_utils/common_import.dart';
import 'package:tekartik_build_utils/firebase/firebase.dart';

Future<void> main() async {
  if (!isFirebaseSupportedSync) {
    stderr.writeln('firebase CLI not installed');
    return;
  }
  await runCmd(
    FirebaseCmd(firebaseArgs(deploy: true, onlyHosting: true, projectId: 'my-project'))
      ..workingDirectory = 'build',
  );
}
```

### npm install then run a node script

```dart
import 'package:tekartik_build_utils/common_import.dart';

Future<void> main() async {
  if (!isNpmSupported || !isNodeSupported) {
    stderr.writeln('node/npm missing');
    return;
  }
  await runCmd(NpmCmd(['install'])..workingDirectory = 'node_app');
  var result = await runCmd(NodeCmd(['--version']), verbose: false);
  stdout.writeln('node ${result.stdout.toString().trim()}');
}
```

### Bash script and zip the result

```dart
import 'dart:io';

import 'package:tekartik_build_utils/bash/bash.dart';
import 'package:tekartik_build_utils/zip/zip.dart';

Future<void> main() async {
  await bash('''
set -e
rm -rf build/web
dart run build_runner build --release --output build
''', verbose: true, workingDirectory: '.');
  await zip('build/web', dst: 'build/web.zip');
  stdout.writeln('packaged');
}
```

### Ask before deploying, showing the LAN address

```dart
import 'package:tekartik_build_utils/common_import.dart';
import 'package:tekartik_build_utils/net/net.dart';
import 'package:tekartik_build_utils/prompt/prompt.dart';
import 'package:tekartik_build_utils/pub/global.dart';

Future<void> main() async {
  stdout.writeln('serving on ${await getLanLocalhost()}');
  if (!await confirm('Deploy to production')) {
    return;
  }
  await activateIfNeeded('webdev');
  await runCmd(WebDevCmd(['build', '--output', 'web:build/web']));
}
```

## Common mistakes

* Expecting `runCmd` to return a failing `ProcessResult`: it throws, and it is
  verbose unless `verbose: false`.
* Using `process_run`'s `runCmd` semantics after importing `cmd_run.dart`:
  the package's own (throwing) version shadows it.
* Using `android/android_cmd.dart`, `chrome/dartium_main.dart` or the
  `pub serve`/appcache parts of `grind_app.dart` in new code — deprecated or
  obsolete; use `tekartik_android_utils` and a modern build instead.
* Calling `bash(...)` on Windows.
* Adding the package to `dependencies`: it is a build-time tool
  (`publish_to: none`).
