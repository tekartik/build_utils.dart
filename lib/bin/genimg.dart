#!/usr/bin/env dart

import 'dart:async';
import 'package:tekartik_build_utils/genimg/genimg.dart';

Future main(List<String> arguments) async {
  //debugQuickLogging(Level.FINE);
  //arguments = ["$appleStartupCmd", "/media/ssd/devx/git/github.com/tekartik/tekartik_build_utils.dart/example/genimg/startup_logo.png"];
  //arguments = ["$appleIconCmd", "/media/ssd/devx/git/github.com/tekartik/tekartik_build_utils.dart/example/genimg/logo_on_white.png"];

  await argsGenImgConvert(arguments);
  //await genImgConvert(cmd, filePath);
}
