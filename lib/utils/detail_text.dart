import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Widget detailText(String detailText, Object detailValue) {
  return Text.rich(
    textAlign: TextAlign.center,
    TextSpan(
      children: [
        TextSpan(
          text: '$detailText: ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        TextSpan(
          text: detailValue.toString(),
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        ),
        // TextSpan(),
      ],
    ),
  );
}
