import 'package:flutter/material.dart';
import 'package:quran_mawaqit/models/surah_model.dart';
import 'package:sizer/sizer.dart';

import '../surahs_name_with_symbol.dart';

class SurahNameBanner extends StatelessWidget {
  final Surah surahData;

  const SurahNameBanner({super.key, required this.surahData});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Image.asset(
            "lib/images/888-02.png",
            color: Colors.white,
          ),
        ),
        Positioned(
          left: 15.9.w,
          top: 1.6.h,
          child: Text(
            textAlign: TextAlign.center,
            "آياتها\n${surahData.aya}",
            style: TextStyle(
              height: 1,
              color: Colors.white,
              fontSize: 6.5.sp,
              fontFamily: "UthmanicHafs13",
            ),
          ),
        ),
        Center(
          child: Text(
            " سُورَةُ ${SwarNameWithSymbole[surahData.id - 1]}",
            style: TextStyle(
              fontFamily: "UthmanicHafs13",
              fontSize: 16.sp,
              color: Colors.white,
              height: 0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Positioned(
          right: 15.4.w,
          top: 1.6.h,
          child: Text(
            "ترتيبها\n${surahData.id}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              height: 1,
              fontSize: 6.5.sp,
              fontFamily: "UthmanicHafs13",
            ),
          ),
        ),
      ],
    );
  }
}
