import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:args/args.dart';

final analysisOptionFilename = 'analysis_options.yaml';
final commandGetAnalysisOption = 'analysis_options.yaml';

const String argHelpFlag = 'help';
const String argVersionFlag = 'version';
const String argVerboseFlag = 'verbose';
const String argOfflineFlag = "offline";
const String argForceRecursiveFlag = "force-recursive";
const String argDryRunFlag = "dry-run";

final Version binVersion = Version(0, 1, 0);

class PubBinOptions {
  bool dryRun;
  bool oneByOne;
}

void addCommonOptions(ArgParser parser) {
  parser.addFlag(argDryRunFlag, abbr: 'd', help: "Don't execture the command");
  parser.addFlag(argVersionFlag, help: 'Version', negatable: false);
}

Future main(List<String> args) async {
  void _addHelp(ArgParser parser) {
    parser.addFlag(argHelpFlag, abbr: 'h', help: "Help info");
  }

  var parser = ArgParser(allowTrailingOptions: false);
  var analysisOptionParser = ArgParser();
  _addHelp(analysisOptionParser);
  parser.addCommand(commandGetAnalysisOption, analysisOptionParser);
  parser.addFlag(argDryRunFlag, abbr: 'd', help: "Don't execture the command");
  _addHelp(parser);
  parser.addFlag(argVersionFlag, help: 'Version', negatable: false);
  parser.addFlag(argVerboseFlag,
      abbr: 'v', help: 'verbose output', negatable: false);

  var result = parser.parse(args);

  void _version() {
    stdout.write('$binVersion');
  }

  void _help() {
    stdout.writeln('General utility');
    stdout.writeln();
    stdout.writeln(parser.usage);
    stdout.writeln(parser.commands.keys);
  }

  bool version = result[argVersionFlag];
  if (version) {
    _version();
    return;
  }
  bool help = result[argHelpFlag];
  if (help) {
    _help();
    return;
  }

  // devPrint(result.command?.name);
  if (result.command?.name == commandGetAnalysisOption) {
    var getAnalysisOptionResult = result.command;

    void _help() {
      stdout.writeln('Fetch analysis_options.yaml');
      stdout.writeln();
      stdout.writeln(analysisOptionParser.usage);
    }

    bool help = getAnalysisOptionResult[argHelpFlag];
    if (help) {
      _help();
      return;
    }

    void _firstLine(String text) {
      stdout.writeln(const LineSplitter().convert(text).first);
    }

    var urlRoot =
        'https://raw.githubusercontent.com/tekartik/build_utils.dart/dart2/example/analyze/simple_package/analysis_options.yaml';

    var file = File(analysisOptionFilename);
    try {
      var oldYaml = await file.readAsString();
      _firstLine(oldYaml);
    } catch (_) {}
    var analysisOptionsYaml = await read(urlRoot);

    await file.writeAsString(analysisOptionsYaml);
    _firstLine(analysisOptionsYaml);
  } else {
    if (result.rest.isEmpty) {
      _help();
      return;
    }
  }
}
