import 'package:flutter/material.dart';
import 'package:quran_mawaqit/controller/controller.dart';
import 'package:quran_mawaqit/controller/font_manager.dart';
import 'package:quran_mawaqit/data_sources/quran_layout_source.dart';
import 'package:quran_mawaqit/data_sources/quran_word_source.dart';
import 'package:quran_mawaqit/new_trial/quran_line_widget.dart';

class QuranPageViewer extends StatefulWidget {
  final QuranLayoutSource layoutSource;
  final QuranWordSource wordSource;

  const QuranPageViewer({
    super.key,
    required this.layoutSource,
    required this.wordSource,
  });

  @override
  State<QuranPageViewer> createState() => _QuranPageViewerState();
}

class _QuranPageViewerState extends State<QuranPageViewer> {
  List<String> fonts = [];

  late final List layoutLines;
  late final QuranWordSource wordSource;

  @override
  void initState() {
    super.initState();
    layoutLines = widget.layoutSource.getLines();
    wordSource = widget.wordSource;
    _initFonts();
  }

  Future<void> _initFonts() async {
    await FontManager.downloadAndExtractFonts(
      'https://github.com/mawaqit/Mawaqit_Boost_Projects/raw/refs/heads/main/public/QPC%20V1%20Font.ttf.zip',
    );

    final availableFonts = await FontManager.listAvailableFonts();
    if (availableFonts.isNotEmpty) {
      await FontManager.loadAllFonts();
      setState(() => fonts = availableFonts);
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
                controller: QuranController.pageController,
                itemCount: 604,
                itemBuilder: (context, pageIndex) {
                  final pageLines = layoutLines
                      .where((line) => line.pageNumber == pageIndex)
                      .toList()
                    ..sort((a, b) => a.lineNumber.compareTo(b.lineNumber));

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: pageLines.map((line) {
                      return QuranLineWidget(
                        index: pageIndex,
                        line: line,
                        wordSource: wordSource,
                        fontFamily: 'p$pageIndex',
                      );
                    }).toList(),
                  );
                },
              ),
              _buildPageJumpField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageJumpField() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        color: Colors.white,
        width: 60,
        height: 40,
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
          ),
          onSubmitted: (value) {
            final page = int.tryParse(value);
            if (page != null && page >= 1 && page <= 604) {
              QuranController.pageController.jumpToPage(page);
            }
          },
        ),
      ),
    );
  }
}
