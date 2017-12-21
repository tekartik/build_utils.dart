#!/bin/bash

# Fast fail the script on failures.
set -e

dartanalyzer --fatal-warnings \
  lib/common_import.dart \
  lib/appcache.dart \
  lib/cmd_run.dart \
  lib/maven.dart \
  lib/grind/grind_app.dart \

pub run test -p vm -j 1 -r expanded
