import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';

class CustomInteractiveTooltip {
  static InteractiveTooltip create({required String format}) {
    return InteractiveTooltip(
      enable: true,
      canShowMarker: false,
      color: UIColours.white,
      borderWidth: 0.0,
      borderRadius: 4,
      borderColor: Colors.transparent,
      textStyle: UIText.xsmall,
      format: format,
    );
  }
}