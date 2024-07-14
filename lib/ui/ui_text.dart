import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robinbank_app/ui/ui_colours.dart';

class UIText {
  UIText._();

  // text
  static final TextStyle brand = GoogleFonts.openSansCondensed(
    textStyle: const TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      color: UIColours.blue,
    ),
  );

  static final TextStyle heading = GoogleFonts.heebo(
    textStyle: const TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: UIColours.primaryText,
    ),
  );

  static final TextStyle large = GoogleFonts.heebo(
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: UIColours.primaryText,
    ),
  );

  static final TextStyle medium = GoogleFonts.heebo(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: UIColours.primaryText,
    ),
  );

  static final TextStyle small = GoogleFonts.heebo(
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: UIColours.primaryText,
    ),
  );

  static final TextStyle xsmall = GoogleFonts.heebo(
    textStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: UIColours.primaryText,
    ),
  );
}
