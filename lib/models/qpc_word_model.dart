
import '../constants/qpc_v1_word.dart';

class QpcWordModel {
  final int wordIndex;
  final String location;
  final String text;

  QpcWordModel({
    required this.wordIndex,
    required this.location,
    required this.text,
  });

  factory QpcWordModel.fromMap(Map<String, dynamic> map) {
    return QpcWordModel(
      wordIndex: map['word_index'],
      location: map['location'],
      text: map['text'],
    );
  }
  static Map<int, QpcWordModel> get wordIdMap {
    return Map.fromEntries(
      qpcV1Word.values.map((value) {
        final model = QpcWordModel.fromMap(value);
        return MapEntry(model.wordIndex, model);
      }),
    );
  }




}
