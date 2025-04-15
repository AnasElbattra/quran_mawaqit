import '../constants/qpc_v1_layout.dart';

class QpcLineModel {
  final int pageNumber;
  final int lineNumber;
  final bool isSurahName;
  final bool isBasmallah;
  final bool isCentered;
  final int? firstWordId;
  final int? lastWordId;
  final int? surahNumber;

  QpcLineModel({
    required this.pageNumber,
    required this.lineNumber,
    required this.isSurahName,
    required this.isBasmallah,
    required this.isCentered,
    this.firstWordId,
    this.lastWordId,
    this.surahNumber,
  });

  factory QpcLineModel.fromMap(Map<String, dynamic> map) {
    return QpcLineModel(
      pageNumber: map['page_number'],
      lineNumber: map['line_number'],
      isSurahName: map['line_type']=="surah_name",
      isBasmallah: map['line_type']=="basmallah",
      isCentered: map['is_centered'] == 1,
      firstWordId: map['first_word_id'] == "" ? null : int.tryParse(map['first_word_id'].toString()),
      lastWordId: map['last_word_id'] == "" ? null : int.tryParse(map['last_word_id'].toString()),
      surahNumber: map['surah_number'] == "" ? null : int.tryParse(map['surah_number'].toString()),
    );
  }
  static List<QpcLineModel> get  layoutLines {
    return   qpcV1Layout.map((e) => QpcLineModel.fromMap(e)).toList();

  }
}
