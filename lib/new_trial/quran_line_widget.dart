import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../components/ayah_action_sheet.dart';
import '../components/basmellah.dart';
import '../components/surah_name_banner.dart';
import '../constants/surah_data.dart';
import '../controller/highlight_controller.dart';
import '../models/qcf_layout_model.dart';
import '../models/qcf_word_model.dart';
import '../data_sources/quran_word_source.dart';

class QuranLineWidget extends StatelessWidget {
  final QcfLineModel line;
  final QuranWordSource wordSource;
  final String fontFamily;
  final int index;

  const QuranLineWidget({
    super.key,
    required this.line,
    required this.wordSource,
    required this.fontFamily,
    required this.index,
  });

  /// Decorative banner for surah name
  InlineSpan _buildSurahHeader(int surahIndex) {
    return WidgetSpan(
      child: Align(
        heightFactor: 0.6,
        child: SurahNameBanner(surahData: surahList[surahIndex - 1]),
      ),
    );
  }

  /// Build ayah span line with long press highlighting
  List<InlineSpan> _buildAyahSpans(Set<String> highlightedAyahs, BuildContext context) {
    if (line.firstWordId == null || line.lastWordId == null) return [];

    final List<InlineSpan> spans = [];

    for (int id = line.firstWordId!; id <= line.lastWordId!; id++) {
      final word = wordSource.getWordById(id);
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
              final ayahText = wordSource.getAyahText(ayahKey);

              HighlightController.toggle(ayahKey, ayahText);

              if (HighlightController.selectedAyah == ayahKey) {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  backgroundColor: Colors.grey[900],
                  builder: (_) => AyahActionSheet(ayahText: ayahText),
                );
              }
            },
        ),
      );
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 16,
      width: double.infinity,
      child: Center(
        child: ValueListenableBuilder<Set<String>>(
          valueListenable: HighlightController.highlightedAyahs,
          builder: (_, highlightedAyahs, __) {
            List<InlineSpan> spans;

            if (line.isSurahName) {
              spans = [_buildSurahHeader(line.surahNumber!)];
            } else if (line.isBasmallah) {
              spans = [WidgetSpan(child: Basmallah())];
            } else {
              spans = _buildAyahSpans(highlightedAyahs, context);
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
