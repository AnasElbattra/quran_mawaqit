import 'package:flutter/material.dart';

class HighlightController {
  static final ValueNotifier<Set<String>> highlightedAyahs = ValueNotifier({});
  static String? selectedAyah;
  static String? selectedAyahText;

  static void toggle(String ayahKey, String ayahText) {
    final current = <String>{};

    if (highlightedAyahs.value.contains(ayahKey)) {
      selectedAyah = null;
      selectedAyahText = null;
      highlightedAyahs.value = current;
    } else {
      selectedAyah = ayahKey;
      selectedAyahText = ayahText;
      current.add(ayahKey);
      highlightedAyahs.value = current;
    }
  }

  static bool isHighlighted(String ayahKey) =>
      highlightedAyahs.value.contains(ayahKey);
}
