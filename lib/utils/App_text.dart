
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final Color color;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final double fontSize;
  final double letterSpacing;
  final TextDecoration _textDecoration;


  AppText({
    super.key,
     this.fontWeight = FontWeight.w500,
    this.letterSpacing = 0.1,
    required this.text,
     this.color = Colors.black,
     this.fontSize =14,
    this._textDecoration = TextDecoration.none,
    this.textAlign = TextAlign.start
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        letterSpacing: letterSpacing,
          decoration: _textDecoration
      ),
      textAlign:textAlign ,

    );
  }
}
