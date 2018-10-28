#!/bin/bash

# Fast fail the script on failures.
set -e

dartanalyzer --fatal-warnings lib test example

# pub run test -p vm -j 1 -r expanded
pub run test -p vm
pub run build_runner test
