

import 'package:quran_mawaqit/data_sources/quran_layout_source.dart';

import '../constants/qpc_v1_layout.dart';
import '../models/qpc_layout_model.dart';

class QpcV1LayoutSource implements QuranLayoutSource {
  @override
  List<QpcLineModel> getLines() {
    return qpcV1Layout.map((e) => QpcLineModel.fromMap(e)).toList();
  }
}
