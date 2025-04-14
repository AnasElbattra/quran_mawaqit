import 'package:flutter/material.dart';

class HighlightController {
  static final ValueNotifier<Set<String>> highlightedAyahs = ValueNotifier({});

  static void toggle(String ayahKey) {
    final current = Set<String>.from(highlightedAyahs.value);
    if (current.contains(ayahKey)) {
      current.remove(ayahKey);
    } else {
      current.add(ayahKey);
    }
    highlightedAyahs.value = current;
  }

  static bool isHighlighted(String ayahKey) =>
      highlightedAyahs.value.contains(ayahKey);
}
