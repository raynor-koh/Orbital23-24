import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:robinbank_app/components/chart_data_point.dart';
import 'package:robinbank_app/services/alpaca_service.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CandlestickChart extends StatefulWidget {
  final String symbol;

  const CandlestickChart({
    super.key,
    required this.symbol,
  });

  @override
  State<CandlestickChart> createState() => _CandlestickChartState();
}

class _CandlestickChartState extends State<CandlestickChart> {
  late Future<List<ChartDataPoint>> _chartDataPointsFuture;
  late TrackballBehavior _trackballBehaviour;
  late ZoomPanBehavior _zoomPanBehaviour;

  @override
  void initState() {
    super.initState();
    _chartDataPointsFuture = AlpacaService().getChartDataPoints(widget.symbol);
    _trackballBehaviour = TrackballBehavior(
      enable: true,
      lineType: TrackballLineType.vertical,
      lineColor: UIColours.blue,
      lineWidth: 1,
      lineDashArray: [2, 1],
      hideDelay: 3000,
      activationMode: ActivationMode.longPress,
      tooltipSettings: InteractiveTooltip(
        enable: true,
        canShowMarker: false,
        color: UIColours.white,
        borderWidth: 0.0,
        borderRadius: 4,
        borderColor: Colors.transparent,
        textStyle: UIText.xsmall,
        format: 'point.x\nOpen: point.open\nHigh: point.high\nLow: point.low\nClose: point.close',
      ),
    );
    _zoomPanBehaviour = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      zoomMode: ZoomMode.x,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChartDataPoint>>(
      future: _chartDataPointsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: RefreshProgressIndicator(
              backgroundColor: UIColours.white,
              color: UIColours.blue,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final chartDataPoints = snapshot.data!;
          return Column(
            children: [
              SizedBox(
                height: 270,
                child: SfCartesianChart(
                  backgroundColor: UIColours.background1,
                  borderColor: UIColours.background2,
                  borderWidth: 1,
                  plotAreaBorderWidth: 0.0,
                  trackballBehavior: _trackballBehaviour,
                  zoomPanBehavior: _zoomPanBehaviour,
                  series: [
                    CandleSeries<ChartDataPoint, DateTime>(
                      dataSource: chartDataPoints,
                      xValueMapper: (ChartDataPoint point, _) => point.dateTime,
                      openValueMapper: (ChartDataPoint point, _) => point.open,
                      highValueMapper: (ChartDataPoint point, _) => point.high,
                      lowValueMapper: (ChartDataPoint point, _) => point.low,
                      closeValueMapper: (ChartDataPoint point, _) => point.close,
                      enableSolidCandles: false,
                      bearColor: Colors.red,
                      bullColor: Colors.green,
                      borderWidth: 1,
                      animationDuration: 1000,
                      trendlines: chartDataPoints.isNotEmpty ? [
                      Trendline(
                        type: TrendlineType.movingAverage,
                        width: 1,
                        color: UIColours.blue,
                      ),
                    ] : [],
                    ),
                  ],
                  primaryXAxis: DateTimeAxis(
                    dateFormat: DateFormat('MM/dd HH.mm'),
                    autoScrollingDelta: 30,
                    autoScrollingDeltaType: DateTimeIntervalType.minutes,
                    autoScrollingMode: AutoScrollingMode.end,
                    majorGridLines: const MajorGridLines(width: 0),
                    isVisible: false,
                  ),
                  primaryYAxis: const NumericAxis(
                    isVisible: false,
                  ),
                ),
              ),
              SizedBox(
                height: 80,
                child: SfCartesianChart(
                  backgroundColor: UIColours.background1,
                  borderColor: UIColours.background2,
                  borderWidth: 1,
                  plotAreaBorderWidth: 0.0,
                  series: [
                    ColumnSeries<ChartDataPoint, DateTime>(
                      dataSource: chartDataPoints,
                      xValueMapper: (ChartDataPoint point, _) => point.dateTime,
                      yValueMapper: (ChartDataPoint point, _) => point.volume,
                      color: UIColours.blue,
                      borderWidth: 1,
                    ),
                  ],
                  primaryXAxis: DateTimeAxis(
                    dateFormat: DateFormat('MM/dd HH.mm'),
                    autoScrollingDelta: 30,
                    autoScrollingDeltaType: DateTimeIntervalType.minutes,
                    autoScrollingMode: AutoScrollingMode.end,
                    majorGridLines: const MajorGridLines(width: 0),
                    isVisible: false,
                  ),
                  primaryYAxis: const NumericAxis(
                    isVisible: false,
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
