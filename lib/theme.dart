import 'package:flutter/material.dart';

const colorTheme = Color(0xFFf54282);
const colorSecond = Color(0xFF2f6fdb);
const colorYellow = Color(0xFFfcc318);
const colorWhite = Color(0xFFFFFFFF);
const colorBlack = Color(0xFF000000);
const colorGrey1 = Color(0xFF9B9B9B);
const colorGrey2 = Color(0xFF909090);
const colorGreyBorder = Color(0xFFF1F1F1);
const colorGreyBg = Color(0xFFD9D9D9);

extension MediaQueryValues on BuildContext {
  double get w => MediaQuery.of(this).size.width;
  double get h => MediaQuery.of(this).size.height;
}

class PrimaryFont {
  static TextStyle fontSize(double size) {
    return TextStyle(
      fontFamily: 'Nunito',
      fontSize: size,
    );
  }

  static TextStyle bold(double size) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.bold
    );
  }
}