import '../constants/qcf_v1_word.dart';
import '../models/qcf_word_model.dart';
import 'quran_word_source.dart';

class QpcV1WordSource implements QuranWordSource {
  final Map<int, QcfWordModel> _wordMap = Map.fromEntries(
    qcfV1Word.values.map((value) {
      final model = QcfWordModel.fromMap(value);
      return MapEntry(model.wordIndex, model);
    }),
  );

  @override
  Map<int, QcfWordModel> getWordMap() => _wordMap;

  @override
  QcfWordModel? getWordById(int id) => _wordMap[id];

  @override
  String getAyahText(String ayahKey) {
    return _wordMap.values
        .where((w) => w.location.startsWith(ayahKey))
        .map((w) => w.text)
        .join(' ');
  }
}
