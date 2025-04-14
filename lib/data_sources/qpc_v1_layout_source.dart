

import 'package:quran_mawaqit/data_sources/quran_layout_source.dart';

import '../constants/qcf_v1_layout.dart';
import '../models/qcf_layout_model.dart';

class QpcV1LayoutSource implements QuranLayoutSource {
  @override
  List<QcfLineModel> getLines() {
    return qcfV1Layout.map((e) => QcfLineModel.fromMap(e)).toList();
  }
}
