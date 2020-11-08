#!/usr/bin/env dart

import 'dart:async';

import 'git_log/git_log_command.dart' as app;

Future main(List<String> arguments) async {
  //debugQuickLogging(Level.FINE);
  //arguments = ["$appleStartupCmd", "/media/ssd/devx/git/github.com/tekartik/tekartik_build_utils.dart/example/genimg/startup_logo.png"];
  //arguments = ["$appleIconCmd", "/media/ssd/devx/git/github.com/tekartik/tekartik_build_utils.dart/example/genimg/logo_on_white.png"];

  await app.main(arguments);
  //await genImgConvert(cmd, filePath);
}
