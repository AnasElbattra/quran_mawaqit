import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class FontManager {
  static Future<void> downloadAndExtractFonts(String url) async {
    final dir = await getApplicationDocumentsDirectory();
    final fontsDir = Directory('${dir.path}/fonts');
    final zipFilePath = '${dir.path}/fonts.zip';

    // ✅ Check if fonts already extracted
    if (fontsDir.existsSync() && fontsDir.listSync().any((f) => f.path.endsWith('.ttf'))) {
      print('✅ Fonts already extracted.');
      return;
    }

    // ✅ If ZIP already downloaded, use it. Otherwise, download it
    File zipFile = File(zipFilePath);
    if (!await zipFile.exists()) {
      print('⬇️ Downloading font zip...');
      final response = await http.get(Uri.parse(url));
      await zipFile.writeAsBytes(response.bodyBytes);
    } else {
      print('📦 ZIP already exists. Using cached zip.');
    }

    // ✅ Extract ZIP
    final bytes = await zipFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    if (!fontsDir.existsSync()) {
      fontsDir.createSync(recursive: true);
    }

    for (final file in archive) {
      if (file.isFile && file.name.endsWith('.ttf')) {
        final filename = file.name.split('/').last;
        final outFile = File('${fontsDir.path}/$filename');
        await outFile.writeAsBytes(file.content as List<int>);
      }
    }

    print('✅ Fonts extracted.');
  }


  static Future<void> loadAllFonts() async {
    final dir = await getApplicationDocumentsDirectory();
    final fontsDir = Directory('${dir.path}/fonts');

    if (!await fontsDir.exists()) return;

    final fontFiles = fontsDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.toLowerCase().endsWith('.ttf'));

    for (final file in fontFiles) {
      final fontName = file.uri.pathSegments.last.replaceAll('.ttf', '');

      final bytes = await file.readAsBytes();
      final byteData = ByteData.view(bytes.buffer);

      final fontLoader = FontLoader(fontName);
      fontLoader.addFont(Future.value(byteData));
      await fontLoader.load();
    }
  }

  static Future<List<String>> listAvailableFonts() async {
    final dir = await getApplicationDocumentsDirectory();
    final fontsDir = Directory('${dir.path}/fonts');
    final fontFiles = fontsDir.listSync().whereType<File>();

    return fontFiles
        .where((f) => f.path.endsWith('.ttf'))
        .map((f) => f.uri.pathSegments.last.replaceAll('.ttf', ''))
        .toList();
  }
}
