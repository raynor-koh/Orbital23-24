import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';
import 'package:intl/intl.dart';

class CustomXAxis {
  static DateTimeAxis create({
    required int autoScrollingDelta,
  }) {
    return DateTimeAxis(
      dateFormat: DateFormat('HH.mm'),
      autoScrollingDelta: autoScrollingDelta,
      autoScrollingDeltaType: DateTimeIntervalType.minutes,
      autoScrollingMode: AutoScrollingMode.end,
      isVisible: true,
      labelStyle: UIText.xsmall,
      majorGridLines: const MajorGridLines(
        width: 1,
        color: UIColours.background2,
      ),
      plotOffset: 0,
      labelPosition: ChartDataLabelPosition.inside,
      labelAlignment: LabelAlignment.center,
      edgeLabelPlacement: EdgeLabelPlacement.shift,
      crossesAt: 0,
    );
  }
}
