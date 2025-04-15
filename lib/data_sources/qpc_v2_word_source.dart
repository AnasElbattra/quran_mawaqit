import '../constants/qpc_v2_word.dart';
import '../models/qpc_word_model.dart';
import 'quran_word_source.dart';

class QpcV2WordSource implements QuranWordSource {
  final Map<int, QpcWordModel> _wordMap = Map.fromEntries(
    qpcV2Word.values.map((value) {
      final model = QpcWordModel.fromMap(value);
      return MapEntry(model.wordIndex, model);
    }),
  );

  @override
  Map<int, QpcWordModel> getWordMap() => _wordMap;

  @override
  QpcWordModel? getWordById(int id) => _wordMap[id];

  @override
  String getAyahText(String ayahKey) {
    return _wordMap.values
        .where((w) => w.location.startsWith(ayahKey))
        .map((w) => w.text)
        .join(' ');
  }
}
