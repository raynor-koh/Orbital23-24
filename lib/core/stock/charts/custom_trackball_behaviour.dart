import 'package:flutter/material.dart';
import 'package:robinbank_app/core/stock/charts/custom_interactive_tooltip.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CustomTrackballBehaviour {
  static TrackballBehavior create({
    required String tooltipFormat,
    required bool isMarkerVisible,
  }) {
    return TrackballBehavior(
      enable: true,
      lineType: TrackballLineType.vertical,
      lineColor: UIColours.blue,
      lineWidth: 1,
      lineDashArray: [2, 1],
      hideDelay: 3000,
      activationMode: ActivationMode.longPress,
      tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
      tooltipSettings: CustomInteractiveTooltip.create(format: tooltipFormat),
      markerSettings: TrackballMarkerSettings(
        markerVisibility: isMarkerVisible ? TrackballVisibilityMode.visible : TrackballVisibilityMode.hidden,
        height: 8,
        width: 8,
        borderWidth: 0,
        borderColor: Colors.transparent,
        color: UIColours.blue
      ),
    );
  }
}
