import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';

class FontLoaderUtil {
  static Future<void> extractAndLoadFonts() async {
    try {
      // 1. Get the application documents directory
      final directory = await getApplicationDocumentsDirectory();
      final fontsDirectory = Directory('${directory.path}/fonts');
      
      // Create fonts directory if it doesn't exist
      if (!await fontsDirectory.exists()) {
        await fontsDirectory.create(recursive: true);
      }

      // 2. Load the zip file from assets
      final ByteData data = await rootBundle.load('assets/qpc_v2.zip');
      final Uint8List bytes = data.buffer.asUint8List();

      // 3. Extract the zip file
      final archive = ZipDecoder().decodeBytes(bytes);

      // 4. Extract TTF files and save them to the fonts directory
      for (final file in archive) {
        if (file.name.toLowerCase().endsWith('.ttf')) {
          final File outFile = File('${fontsDirectory.path}/${file.name}');
          await outFile.writeAsBytes(file.content as List<int>);
        }
      }

      // 5. Load the fonts into the app
      final fontFiles = fontsDirectory.listSync();
      for (final file in fontFiles) {
        if (file.path.toLowerCase().endsWith('.ttf')) {
          final fontLoader = FontLoader(file.path.split('/').last.split('.').first);
          fontLoader.addFont(File(file.path).readAsBytes().then((bytes) => ByteData.view(bytes.buffer)));
          await fontLoader.load();
        }
      }
    } catch (e) {
      print('Error loading fonts: $e');
    }
  }
}