import 'package:archive/archive_io.dart';
import 'package:tekartik_build_utils/common_import.dart';

/// [dst] is a .zip file name
Future zip(String directoryPath, {String? dst}) async {
  dst ??= join(
      dirname(directoryPath), '${basenameWithoutExtension(directoryPath)}.zip');

  await Directory(dirname(dst)).create(recursive: true);
  ZipFileEncoder().zipDirectory(Directory(directoryPath), filename: dst);
}
