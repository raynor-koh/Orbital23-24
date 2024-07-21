import 'package:syncfusion_flutter_charts/charts.dart';

class CustomZoomPanBehaviour {
  static ZoomPanBehavior create() {
    return ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      zoomMode: ZoomMode.x,
    );
  }
}