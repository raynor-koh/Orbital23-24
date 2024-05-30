import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robinbank_app/ui/ui_colours.dart';

class UIText {
  // private constructor
  UIText._();

  // text
  static final TextStyle brand = GoogleFonts.openSansCondensed(
    textStyle: const TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      color: UIColours.blue,
    ),
  );

  static final TextStyle heading = GoogleFonts.readexPro(
    textStyle: const TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: UIColours.neutral,
    ),
  );

  static final TextStyle large = GoogleFonts.readexPro(
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: UIColours.neutral,
    ),
  );

  static final TextStyle medium = GoogleFonts.readexPro(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: UIColours.neutral,
    ),
  );

  static final TextStyle small = GoogleFonts.readexPro(
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: UIColours.neutral,
    ),
  );

  static final TextStyle xsmall = GoogleFonts.readexPro(
    textStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: UIColours.neutral,
    ),
  );
}
