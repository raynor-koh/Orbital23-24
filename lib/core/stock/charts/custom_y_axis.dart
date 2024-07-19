import 'package:syncfusion_flutter_charts/charts.dart';

class CustomYAxis {
  static NumericAxis create() {
    return const NumericAxis(
      anchorRangeToVisiblePoints: true,
      isVisible: false,
    );
  }
}
