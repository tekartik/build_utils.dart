import 'package:tekartik_build_utils/common_import.dart';
import 'package:archive/archive_io.dart';
import 'package:tekartik_io_utils/file_utils.dart';

Future unzip(String zipFilePath, {String dst}) async {
  dst ??= join(dirname(zipFilePath), basenameWithoutExtension(zipFilePath));
  // Read the Zip file from disk.
  List<int> bytes = await File(zipFilePath).readAsBytes();

  // Decode the Zip file
  Archive archive = ZipDecoder().decodeBytes(bytes);

  // Extract the contents of the Zip archive to disk.
  for (ArchiveFile file in archive) {
    String filename = file.name;
    if (file.isFile) {
      List<int> data = file.content;
      var outFile = File(join(dst, filename));
      await outFile.parent.createSync(recursive: true);
      await outFile.writeAsBytes(data, flush: true);

      // devPrint(file.mode?.toRadixString(16));
      // devPrint(file.unixPermissions?.toRadixString(16));
      // Support file permission
      if (supportsFilePermission && (file.unixPermissions != null) && ((file.unixPermissions & executablePermissionModeMask) != 0)) {
        await setExecutablePermission(outFile.path);
      }

    } else {
      var outDir = Directory(join(dst, filename));
      await outDir.create(recursive: true);
    }
  }
}
