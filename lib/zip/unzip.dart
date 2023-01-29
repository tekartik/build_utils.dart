import 'package:tekartik_app_io_zip/zip.dart' as impl;

// To deprecated
Future unzip(String zipFilePath, {String? dst}) =>
    impl.unzip(zipFilePath, dst: dst);
