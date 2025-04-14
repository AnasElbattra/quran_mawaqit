import '../models/qcf_word_model.dart';

abstract class QuranWordSource {
  Map<int, QcfWordModel> getWordMap();

  QcfWordModel? getWordById(int id);

  String getAyahText(String ayahKey); // example: "2:255"
}