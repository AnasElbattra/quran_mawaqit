import '../constants/qcf_v1_word.dart';

class QcfWordModel {
  final int wordIndex;
  final String location;
  final String text;

  QcfWordModel({
    required this.wordIndex,
    required this.location,
    required this.text,
  });

  factory QcfWordModel.fromMap(Map<String, dynamic> map) {
    return QcfWordModel(
      wordIndex: map['word_index'],
      location: map['location'],
      text: map['text'],
    );
  }
  static Map<int, QcfWordModel> get wordIdMap {
    return Map.fromEntries(
      qcfV1Word.values.map((value) {
        final model = QcfWordModel.fromMap(value);
        return MapEntry(model.wordIndex, model);
      }),
    );
  }




}
