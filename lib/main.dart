import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'data_sources/qpc_v1_layout_source.dart';
import 'data_sources/qpc_v1_word_source.dart';
import 'new_trial/quran_page_viewer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: QuranPageViewer(
            layoutSource: QpcV1LayoutSource(),
            wordSource: QpcV1WordSource(),
          ),
        );
      },
    );
  }
}
