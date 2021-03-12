import 'package:args/args.dart';
import 'package:path/path.dart';
import 'package:tekartik_build_utils/cmd_run.dart';
import 'package:tekartik_io_utils/io_utils_import.dart';

const String appleStartupCmd = 'apple_startup';
const String appleIconCmd = 'apple_icon';
final version = Version(0, 1, 0);

class ConvertParams {
  int width = 500;
  int height = 500;

  String src;
  String dstBase;

  bool resize;
  bool extent;
}

Future convert(ConvertParams options) async {
  final src = options.src;
  final width = options.width;
  final height = options.height;
  final dir = dirname(src);
  final ext = extension(src);
  var dstBase = options.dstBase;
  dstBase ??= basename(src);

  final dst = join(dir, '${dstBase}_${width}x$height$ext');

  if (options.resize == true) {
    await runCmd(ProcessCmd('convert', [
      '-background',
      'white',
      '-gravity',
      'center',
      src,
      '-resize',
      '${width}x$height',
      dst
    ]));
  } else if (options.extent == true) {
//  cmd = 'apple_startup';
//  String filePath = '/media/ssd/devx/git/github.com/tekartik/tekartik_build_utils.dart/example/genimg/startup_logo.png';

    await runCmd(ProcessCmd('convert', [
      '-background',
      'white',
      '-gravity',
      'center',
      src,
      '-extent',
      '${width}x$height',
      dst
    ]));
  }

  /*
  switch (cmd) {

  }
  */
}

Future appleStartupConvert(String src) async {
  final convert = AppleStartupImgConvert();
  convert.src = src;

  await convert.perform();
  /*
  ConvertParams params = new ConvertParams();
  params.width = 1004;
  params.height = 768;
  params.src = src;

  await convert(params);
  */
}

class AppleStartupImgConvert {
  String src;
  File htmlFile;

  String dstBase = 'apple_touch_startup_image';

  String get htmlDstFilePath {
    final dir = dirname(src);

    return join(dir, 'apple_touch_icon.html');
  }

  Future perform() async {
    htmlFile = File(htmlDstFilePath);
    //IOSink sink = htmlFile.openWrite();

    final params = ConvertParams();
    params.extent = true;
    params.src = src;
    params.dstBase = dstBase;

    for (var size in [
      [320, 480],
      [768, 1004],
      [1004, 768]
    ]) {
      params.width = size[0];
      params.height = size[1];

      await convert(params);
    }

    //await sink.writeln('')
  }
}

class AppleIconConvert {
  String src;
  File htmlFile;

  String dstBase = 'apple_touch_icon';

  String get htmlDstFilePath {
    final dir = dirname(src);
    return join(dir, 'apple_touch_icon.html');
  }

  Future perform() async {
    htmlFile = File(htmlDstFilePath);
    //IOSink sink = htmlFile.openWrite();

    final params = ConvertParams();
    params.resize = true;
    params.src = src;
    params.dstBase = dstBase;

    for (final width in [60, 76, 120, 152]) {
      params.width = width;
      params.height = width;

      await convert(params);
    }

    //await sink.writeln('')
  }
}

Future appleIconConvert(String src) async {
  final convert = AppleIconConvert();
  convert.src = src;

  await convert.perform();
}

const String _help = 'help';

String get currentScriptName => basenameWithoutExtension(Platform.script.path);

Future argsGenImgConvert(List<String> args) async {
  final parser = ArgParser(allowTrailingOptions: true);
  parser.addFlag(_help, abbr: 'h', help: 'Usage help', negatable: false);
  parser.addFlag('version',
      help: 'Display the script version', negatable: false);

  final _argsResult = parser.parse(args);

  void _usage() {
    stdout.writeln(
        'Generate image from source (local) to remote destination (gs://');
    stdout.writeln('');
    print(
        '  $currentScriptName apple_startup /my/folder gs://my.bucket/my_folder');
    stdout.writeln('');

    stdout.writeln(parser.usage);
  }

  final help = _argsResult[_help] as bool;
  if (help) {
    _usage();
    return null;
  }

  if (_argsResult['version'] as bool) {
    stdout.writeln('$currentScriptName $version');
    return null;
  }

  if (_argsResult.rest.length < 2) {
    _usage();
    return null;
  }

  final cmd = _argsResult.rest[0];
  final filePath = _argsResult.rest[1];

  await genImgConvert(cmd, filePath);
}

Future genImgConvert(String cmd, String src) async {
  switch (cmd) {
    case appleStartupCmd:
      await appleStartupConvert(src);
      break;
    case appleIconCmd:
      await appleIconConvert(src);
      break;
    default:
      stderr.writeln('Unsupported command $cmd');
  }
}

/*
<link rel='apple-touch-icon' href='touch-icon-iphone.png'>
<link rel='apple-touch-icon' sizes='76x76' href='touch-icon-ipad.png'>
<link rel='apple-touch-icon' sizes='120x120' href='touch-icon-iphone-retina.png'>
<link rel='apple-touch-icon' sizes='152x152' href='touch-icon-ipad-retina.png'>
 */
