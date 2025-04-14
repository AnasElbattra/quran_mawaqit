import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:quran_mawaqit/controller/controller.dart';
import 'package:quran_mawaqit/new_trial/quran_line_widget.dart';

import '../basmellah.dart';
import '../font_manager.dart';
import '../header_widget.dart';
import '../models/qcf_layout_model.dart';
import '../models/qcf_word_model.dart';
import '../tail_list_page.dart';

class QuranPageViewer extends StatefulWidget {
  final List<QcfLineModel> layoutLines;
  final Map<int, QcfWordModel> wordMap;

  const QuranPageViewer({
    super.key,
    required this.layoutLines,
    required this.wordMap,
  });

  @override
  State<QuranPageViewer> createState() => _QuranPageViewerState();
}

class _QuranPageViewerState extends State<QuranPageViewer> {
  dynamic fonts;

  @override
  void initState() {
    super.initState();

    initFonts();

  }

  Future<void> initFonts() async {
    await FontManager.downloadAndExtractFonts(
        'https://github.com/mawaqit/Mawaqit_Boost_Projects/raw/refs/heads/main/public/QPC%20V1%20Font.ttf.zip');

    final availableFonts = await FontManager.listAvailableFonts();
    if (availableFonts.isNotEmpty) {
      await FontManager.loadAllFonts();
      setState(() {
        fonts = availableFonts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(
            children: [
              PageView.builder(
                  itemCount: 604,
                  controller: QuranController.pageController,
                  itemBuilder: (context, index) {
                    final linesForPage = widget.layoutLines
                        .where((line) => line.pageNumber == index)
                        .toList()
                      ..sort((a, b) => a.lineNumber.compareTo(b.lineNumber));
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: linesForPage.map((line) {
                        return QuranLineWidget(
                          index: index,
                          line: line,
                          wordMap: widget.wordMap,
                          fontFamily: 'p$index',
                        );
                      }).toList(),
                    );
                  }),
              Positioned(
                bottom: 0,
                right: 0,
                child: Row(
                  children: [
                    Container(
                        color: Colors.white,
                        width: 60,
                        height: 40,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onSubmitted: (value) {
                            if (int.parse(value) <= 604) {
                              QuranController.pageController.jumpToPage(int.parse(value));
                            }
                          },
                        )),
                  ],
                ),
              ),
        
            ],
          ),
        ),
      ),
    );
  }
}
