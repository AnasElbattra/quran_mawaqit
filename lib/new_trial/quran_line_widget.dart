import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../basmellah.dart';
import '../components/ayah_action_sheet.dart';
import '../components/surah_name_banner.dart';
import '../constants/surah_data.dart';
import '../controller/highlight_controller.dart';
import '../models/qcf_layout_model.dart';
import '../models/qcf_word_model.dart';

class QuranLineWidget extends StatelessWidget {
  final QcfLineModel line;
  final Map<int, QcfWordModel> wordMap;
  final String fontFamily;
  final int index;

  const QuranLineWidget({
    super.key,
    required this.line,
    required this.wordMap,
    required this.fontFamily,
    required this.index,
  });

  InlineSpan _buildSurahHeader(int surahIndex) {
    return WidgetSpan(
      child: Align(
        heightFactor: 0.6,
        child: SurahNameBanner(surahData: surahList[surahIndex - 1]),
      ),
    );
  }

   List<InlineSpan> _buildWordSpans(Set<String> highlightedAyahs,BuildContext context) {
    List<InlineSpan> spans = [];

    if (line.firstWordId == null || line.lastWordId == null) return spans;

    for (int id = line.firstWordId!; id <= line.lastWordId!; id++) {
      final word = wordMap[id];
      if (word == null) continue;

      final ayahKey = word.location.split(":").take(2).join(":");
      final isHighlighted = highlightedAyahs.contains(ayahKey);

      spans.add(
        TextSpan(
          text: word.text,
          style: TextStyle(
            backgroundColor: isHighlighted
                ? Colors.deepPurple.withOpacity(0.4)
                : Colors.transparent,
          ),
          recognizer: LongPressGestureRecognizer()
            ..onLongPress = () {
              final ayahWords = wordMap.values
                  .where((w) => w.location.startsWith(ayahKey))
                  .map((w) => w.text)
                  .join(' ');

              HighlightController.toggle(ayahKey, ayahWords);

              if (HighlightController.selectedAyah == ayahKey) {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  backgroundColor: Colors.grey[900],
                  builder: (_) => AyahActionSheet(ayahText: ayahWords),
                );
              }
            }
        ),
      );
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height/16,
      width: double.infinity,
      child: Center(
        child: ValueListenableBuilder<Set<String>>(
          valueListenable: HighlightController.highlightedAyahs,
          builder: (_, highlightedAyahs, __) {
            List<InlineSpan> spans;

            if (line.isSurahName) {
              final surahNumber = line.surahNumber!;
              spans = [_buildSurahHeader(surahNumber)];
            } else if (line.isBasmallah) {
              spans = [WidgetSpan(child: Basmallah())];
            } else {
              spans = _buildWordSpans(highlightedAyahs,context);
            }

            return RichText(
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              text: TextSpan(
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 21.sp,
                  color: Colors.white,
                  height: 1.7,
                ),
                children: spans,
              ),
            );
          },
        ),
      ),
    );
  }
}
