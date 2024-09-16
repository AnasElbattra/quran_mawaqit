import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:quran_mawaqit/tail_list_page.dart';
import 'package:sizer/sizer.dart';

import 'basmellah.dart';
import 'header_widget.dart';
import 'list_pages_with_different_font.dart';

class Result {
  bool includesQuarter;
  int index;
  int hizbIndex;
  int quarterIndex;

  Result(this.includesQuarter, this.index, this.hizbIndex, this.quarterIndex);
}

class QuranText extends StatefulWidget {
  final Color pageColor;

  const QuranText({
    super.key,
    this.pageColor = Colors.indigo,
  });

  @override
  State<QuranText> createState() => _QuranTextState();
}

class _QuranTextState extends State<QuranText> {
  Result checkIfPageIncludesQuarterAndQuarterIndex(array, pageData, indexes) {
    for (int i = 0; i < array.length; i++) {
      int surah = array[i]['surah'];
      int ayah = array[i]['ayah'];
      for (int j = 0; j < pageData.length; j++) {
        int pageSurah = pageData[j]['surah'];
        int start = pageData[j]['start'];
        int end = pageData[j]['end'];
        if ((surah == pageSurah) && (ayah >= start) && (ayah <= end)) {
          int targetIndex = i + 1;
          for (int hizbIndex = 0; hizbIndex < indexes.length; hizbIndex++) {
            List<int> hizb = indexes[hizbIndex];
            for (int quarterIndex = 0;
                quarterIndex < hizb.length;
                quarterIndex++) {
              if (hizb[quarterIndex] == targetIndex) {
                return Result(true, i, hizbIndex, quarterIndex);
              }
            }
          }
        }
      }
    }
    return Result(false, -1, -1, -1);
  } //Create an instance of ScreenshotController

  List<GlobalKey> richTextKeys = List.generate(
    604, // Replace with the number of pages in your PageView
    (_) => GlobalKey(),
  );

  PageController pageController = PageController();

  InlineSpan _buildTail(int index) {
    List<InlineSpan> tailSpans = [];
    if (tailListPage.contains(index)) {
      final pageData = quran.getPageData(index + 1)[0];
      tailSpans.add(WidgetSpan(child: HeaderWidget(pageDataItem: pageData)));
    }

    return TextSpan(children: tailSpans);
  }

  InlineSpan _buildHeader(Map<String, dynamic> pageDataItem, int index) {
    List<InlineSpan> headerSpans = [];
    if (!tailListPage.contains(index - 1)) {
      headerSpans.add(WidgetSpan(
          child: HeaderWidget(
        pageDataItem: pageDataItem,
        addPadding: index == 187,
      )));
    }

    if (index != 187 && index != 1) {
      headerSpans.add(WidgetSpan(child: Basmallah()));
    }

    return TextSpan(children: headerSpans);
  }

  String _getVerseWithoutLastSymbol(int surah, int verse, int start) {
    String verseText = quran.getVerseQCF(surah, verse).replaceAll(' ', '');

    if (verse == start) {
      return "${verseText.substring(0, 1)}\u200A${verseText.substring(1)}"
          .substring(0, verseText.length);
    }

    return verseText.substring(0, verseText.length - 1);
  }

  String _getLastSymbol(int surah, int verse) {
    String verseText = quran.getVerseQCF(surah, verse).replaceAll(' ', '');
    return verseText.isNotEmpty ? verseText.split('').last : '';
  }

  void _onLongPressDown(Map<String, dynamic> e, int i) {
    // setState(() {
    //   selectedSpan = " ${e["surah"]}$i";
    // });
  }

  void _onLongPressUp() {
    // setState(() {
    //   selectedSpan = "";
    // });
  }

  void _onLongPressCancel() {
    // setState(() {
    //   selectedSpan = "";
    // });
  }

  InlineSpan _buildVerseSpan(Map<String, dynamic> e, int i) {
    String verseText = _getVerseWithoutLastSymbol(e["surah"], i, e["start"]);
    String lastSymbol = _getLastSymbol(e["surah"], i);

    return TextSpan(
      children: [
        TextSpan(
          text: verseText,
          style: TextStyle(color: Colors.white),
        ),
        // Last symbol part
        TextSpan(
          text: lastSymbol,
          style: TextStyle(color: Colors.amberAccent),
        ),
      ],
      recognizer: LongPressGestureRecognizer()
        ..onLongPress = () {
          print("longpressed");
        }
        ..onLongPressDown = (details) {
          _onLongPressDown(e, i);
        }
        ..onLongPressUp = () {
          _onLongPressUp();
        }
        ..onLongPressCancel = () {
          _onLongPressCancel();
        },
    );
  }

  List<InlineSpan> _buildPageContent(int index) {
    List<InlineSpan> spans = [];
    final pageData = quran.getPageData(index);

    for (var e in pageData) {
      for (var i = e["start"]; i <= e["end"]; i++) {
        if (i == 1) {
          spans.add(_buildHeader(e, index));
        }

        spans.add(_buildVerseSpan(e, i));
      }
      spans.add(_buildTail(index));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            PageView.builder(
                itemCount: 605,
                controller: pageController,
                itemBuilder: (context, index) {
                  bool isEvenPage = index.isEven;
                  if (index == 0) {
                    return const Center(
                      child: Text(
                        quran.basmala,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: widget.pageColor,
                      boxShadow: [
                        if (isEvenPage) // Add shadow only for even-numbered pages
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            // Controls the spread of the shadow
                            blurRadius: 10,
                            // Controls the blur effect
                            offset: const Offset(
                                -5, 0), // Left side shadow for even numbers
                          ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: index == 34 ? 0.8.w : 1.w),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (index == 1 || index == 2) SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: RichText(
                                key: richTextKeys[index - 1],
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                                softWrap: true,
                                locale: const Locale("ar"),
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        listPageWithBiggerFont.contains(index)
                                            ? 18.67.sp
                                            : listPagesWithDifferentFont
                                                    .contains(index)
                                                ? 18.6.sp
                                                : listPageWithSmallerFont
                                                        .contains(index)
                                                    ? 18.25.sp
                                                    : 18.4.sp,
                                    fontFamily:
                                        'QCF_P${index.toString().padLeft(3, '0')}',
                                  ),
                                  children: _buildPageContent(index),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
            Positioned(
                bottom: 0,
                right: 0,
                child: Row(
                  children: [
                    // MawaqitIconButtonV3(
                    //   icon: Icons.arrow_back_ios_new,
                    //   backgroundColor: Colors.amberAccent,
                    //   onTap: () {
                    //     pageController.previousPage(duration: Duration(milliseconds: 200), curve: Curves.linear);
                    //   },
                    // ),
                    // MawaqitIconButtonV3(
                    //   backgroundColor: Colors.amberAccent,
                    //   icon: Icons.arrow_forward_ios,
                    //   onTap: () {
                    //     pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.linear);
                    //   },
                    // ),
                    Container(
                        color: Colors.white,
                        width: 60,
                        height: 40,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onSubmitted: (value) {
                            if (int.parse(value) <= 604) {
                              pageController.jumpToPage(int.parse(value));
                            }
                          },
                        )),
                  ],
                ))
          ],
        ),
      ),
    ));
  }
}
