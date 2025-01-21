import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

Future<File?> uint8ListToFile(Uint8List? uint8List) async {
  // Get the temporary directory path
  if (uint8List == null) {
    return null;
  }
  final directory = await getTemporaryDirectory();

  // Create a unique file path (e.g., for a temporary file)
  final filePath =
      '${directory.path}/image_${DateTime.now().millisecondsSinceEpoch}.png';

  // Write the Uint8List data to the file
  final file = File(filePath);
  await file.writeAsBytes(uint8List!);

  return file;
}
