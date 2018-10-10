import 'package:tekartik_build_utils/common_import.dart';
import 'package:archive/archive_io.dart';

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
      await outFile.writeAsBytes(data);
    } else {
      var outDir = Directory(join(dst, filename));
      await outDir.create(recursive: true);
    }
  }
}
