import '../constants/qcf_v1_layout.dart';

class QcfLineModel {
  final int pageNumber;
  final int lineNumber;
  final bool isSurahName;
  final bool isBasmallah;
  final bool isCentered;
  final int? firstWordId;
  final int? lastWordId;
  final int? surahNumber;

  QcfLineModel({
    required this.pageNumber,
    required this.lineNumber,
    required this.isSurahName,
    required this.isBasmallah,
    required this.isCentered,
    this.firstWordId,
    this.lastWordId,
    this.surahNumber,
  });

  factory QcfLineModel.fromMap(Map<String, dynamic> map) {
    return QcfLineModel(
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
  static List<QcfLineModel> get  layoutLines {
    return   qcfV1Layout.map((e) => QcfLineModel.fromMap(e)).toList();

  }
}
