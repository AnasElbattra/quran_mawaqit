import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Basmallah extends StatefulWidget {
  Basmallah({super.key, });

  @override
  State<Basmallah> createState() => _BasmallahState();
}

class _BasmallahState extends State<Basmallah> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: double.infinity,
      child: Image.asset(
        "assets/images/Basmala.png",
        color:Colors.white,
        height: 5.h,
      ),
    );
  }
}
