import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart' hide PageScrollPhysics;
import 'package:quran_mawaqit/controller/controller.dart';
import 'package:quran_mawaqit/controller/font_manager.dart';
import 'package:quran_mawaqit/data_sources/quran_layout_source.dart';
import 'package:quran_mawaqit/data_sources/quran_word_source.dart';
import 'package:quran_mawaqit/models/qpc_layout_model.dart';
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
  late final List<QpcLineModel> layoutLines;
  late final QuranWordSource wordSource;
  late final Map<int, List<QpcLineModel>> pageLinesMap;

  @override
  void initState() {
    super.initState();

    layoutLines = widget.layoutSource.getLines().cast<QpcLineModel>();
    wordSource = widget.wordSource;

    final tempMap = <int, List<QpcLineModel>>{};
    for (var line in layoutLines) {
      tempMap.putIfAbsent(line.pageNumber, () => []).add(line);
    }
    tempMap.forEach((_, lines) {
      lines.sort((a, b) => a.lineNumber.compareTo(b.lineNumber));
    });
    pageLinesMap = tempMap;

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
              PreloadPageView.builder(
                controller: QuranController.pageController,

                preloadPagesCount: 3,
                itemCount: 604,
                itemBuilder: (context, pageIndex) {
                  final pageLines = pageLinesMap[pageIndex] ?? [];

                  final pageWidget = RepaintBoundary(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: pageLines.map((line) {
                        return QuranLineWidget(
                          index: pageIndex,
                          line: line,
                          wordSource: wordSource,
                          fontFamily: 'qpc_v2_p$pageIndex',
                        );
                      }).toList(),
                    ),
                  );

                  return pageWidget;
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
