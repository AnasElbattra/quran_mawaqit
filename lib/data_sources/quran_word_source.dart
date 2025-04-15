import '../models/qpc_word_model.dart';

abstract class QuranWordSource {
  Map<int, QpcWordModel> getWordMap();

  QpcWordModel? getWordById(int id);

  String getAyahText(String ayahKey); // example: "2:255"
}