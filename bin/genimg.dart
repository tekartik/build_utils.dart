#!/usr/bin/env dart
import 'package:fs_shim/fs_io.dart';
import 'dart:async';
import 'package:args/args.dart';
import 'package:path/path.dart';
import 'package:tekartik_deploy/gs_deploy.dart';
import 'package:tekartik_deploy/src/bin_version.dart';
import 'package:tekartik_build_utils/cmd_run.dart';
import 'package:tekartik_build_utils/genimg/genimg.dart';

Future main(List<String> arguments) async {
  //debugQuickLogging(Level.FINE);
  //arguments = ["$appleStartupCmd", "/media/ssd/devx/git/github.com/tekartik/tekartik_build_utils.dart/example/genimg/startup_logo.png"];
  //arguments = ["$appleIconCmd", "/media/ssd/devx/git/github.com/tekartik/tekartik_build_utils.dart/example/genimg/logo_on_white.png"];

  await argsGenImgConvert(arguments);
  //await genImgConvert(cmd, filePath);
}
