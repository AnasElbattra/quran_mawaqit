import 'package:flutter/material.dart';
import 'package:quran/quran.dart';
import 'package:quran_mawaqit/surahs_name_with_symbol.dart';
import 'package:sizer/sizer.dart';

class HeaderWidget extends StatelessWidget {
  final pageDataItem;
  final bool addPadding;

  const HeaderWidget({
    super.key,
    required this.pageDataItem,
    this.addPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Center(
              child: Image.asset(
                "lib/images/888-02.png",
                color: Colors.white,
                package: 'quran_mawaqit',
              ),
            ),
            Positioned(
              left: 15.4.w,
              top: 1.5.h,
              child: Text(
                textAlign: TextAlign.center,
                "آياتها\n${getVerseCount(pageDataItem["surah"])}",
                style: TextStyle(
                    height: 1,
                    color: Colors.white,
                    fontSize: 6.5.sp,
                    fontFamily: "UthmanicHafs13"),
              ),
            ),
            Center(
              child: Text(
                " سُورَةُ ${SwarNameWithSymbole[pageDataItem["surah"] - 1]}",
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
              right: 15.w,
              top: 1.5.h,
              child: Text(
                "ترتيبها\n${pageDataItem["surah"]}",
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
        ),
        if (addPadding) SizedBox(height: 1.h)
      ],
    );
  }
}
