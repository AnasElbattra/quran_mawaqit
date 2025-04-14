import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'models/qcf_layout_model.dart';
import 'models/qcf_word_model.dart';
import 'new_trial/quran_page_viewer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: QuranPageViewer(
          layoutLines: QcfLineModel.layoutLines,
          wordMap: QcfWordModel.wordIdMap,
        ),
      );
    });
  }
}
