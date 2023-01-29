import 'package:tekartik_app_io_zip/zip.dart' as impl;

/// To deprecate
/// [dst] is a .zip file name
Future<void> zip(String directoryPath, {String? dst}) =>
    impl.zip(directoryPath, dst: dst);
