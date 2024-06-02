import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartDataPoint {
  final DateTime? dateTime;
  final num? open;
  final num? high;
  final num? low;
  final num? close;
  // changePercent
  // volume

  ChartDataPoint({
    this.dateTime,
    this.open,
    this.high,
    this.low,
    this.close,
  });
}

class CandlestickChart extends StatefulWidget {
  const CandlestickChart({super.key});

  @override
  State<CandlestickChart> createState() => _CandlestickChartState();
}

class _CandlestickChartState extends State<CandlestickChart> {
  late List<ChartDataPoint> _chartDataPoints;
  late TrackballBehavior _trackballBehaviour;
  late ZoomPanBehavior _zoomPanBehaviour;

  @override
  void initState() {
    super.initState();
    _chartDataPoints = getChartDataPoints();
    _trackballBehaviour = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.longPress,
      tooltipSettings: InteractiveTooltip(
        enable: true,
        color: UIColours.white,
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
    return Container(
      height: 250,
      child: SfCartesianChart(
        trackballBehavior: _trackballBehaviour,
        zoomPanBehavior: _zoomPanBehaviour,
        series: <CandleSeries>[
          CandleSeries<ChartDataPoint, DateTime>(
            dataSource: _chartDataPoints,
            xValueMapper: (ChartDataPoint point, _) => point.dateTime,
            openValueMapper: (ChartDataPoint point, _) => point.open,
            highValueMapper: (ChartDataPoint point, _) => point.high,
            lowValueMapper: (ChartDataPoint point, _) => point.low,
            closeValueMapper: (ChartDataPoint point, _) => point.close,
          ),
        ],
        primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat('MM/dd HH.mm'),
          autoScrollingDelta: 5,
          autoScrollingMode: AutoScrollingMode.end,
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: const NumericAxis(
          isVisible: false,
          minimum: 80,
        ),
      ),
    );
  }

  List<ChartDataPoint> getChartDataPoints() {
    return <ChartDataPoint>[
      ChartDataPoint(
          dateTime: DateTime(2024, 01, 11),
          open: 98.97,
          high: 101.19,
          low: 95.36,
          close: 97.13),
      ChartDataPoint(
          dateTime: DateTime(2024, 01, 18),
          open: 98.41,
          high: 101.46,
          low: 93.42,
          close: 101.42),
      ChartDataPoint(
          dateTime: DateTime(2024, 01, 25),
          open: 101.52,
          high: 101.53,
          low: 92.39,
          close: 97.34),
      ChartDataPoint(
          dateTime: DateTime(2024, 02, 01),
          open: 96.47,
          high: 97.33,
          low: 93.69,
          close: 94.02),
      ChartDataPoint(
          dateTime: DateTime(2024, 02, 08),
          open: 93.13,
          high: 96.35,
          low: 92.59,
          close: 93.99),
      ChartDataPoint(
          dateTime: DateTime(2024, 02, 15),
          open: 91.02,
          high: 94.89,
          low: 90.61,
          close: 92.04),
      ChartDataPoint(
          dateTime: DateTime(2024, 02, 22),
          open: 96.31,
          high: 98.0237,
          low: 98.0237,
          close: 96.31),
      ChartDataPoint(
          dateTime: DateTime(2024, 02, 29),
          open: 99.86,
          high: 106.75,
          low: 99.65,
          close: 106.01),
      ChartDataPoint(
          dateTime: DateTime(2024, 03, 07),
          open: 102.39,
          high: 102.83,
          low: 100.15,
          close: 102.26),
      ChartDataPoint(
          dateTime: DateTime(2024, 03, 14),
          open: 101.91,
          high: 106.5,
          low: 101.78,
          close: 105.92),
      ChartDataPoint(
          dateTime: DateTime(2024, 03, 21),
          open: 105.93,
          high: 107.65,
          low: 104.89,
          close: 105.67),
      ChartDataPoint(
          dateTime: DateTime(2024, 03, 28),
          open: 106,
          high: 110.42,
          low: 104.88,
          close: 109.99),
      ChartDataPoint(
          dateTime: DateTime(2024, 04, 04),
          open: 110.42,
          high: 112.19,
          low: 108.121,
          close: 108.66),
      ChartDataPoint(
          dateTime: DateTime(2024, 04, 11),
          open: 108.97,
          high: 112.39,
          low: 108.66,
          close: 109.85),
      ChartDataPoint(
          dateTime: DateTime(2024, 04, 18),
          open: 108.89,
          high: 108.95,
          low: 104.62,
          close: 105.68),
      ChartDataPoint(
          dateTime: DateTime(2024, 04, 25),
          open: 105,
          high: 105.65,
          low: 92.51,
          close: 93.74),
      ChartDataPoint(
          dateTime: DateTime(2024, 05, 02),
          open: 93.965,
          high: 95.9,
          low: 91.85,
          close: 92.72),
      ChartDataPoint(
          dateTime: DateTime(2024, 05, 09),
          open: 93,
          high: 93.77,
          low: 89.47,
          close: 90.52),
      ChartDataPoint(
          dateTime: DateTime(2024, 05, 16),
          open: 92.39,
          high: 95.43,
          low: 91.65,
          close: 95.22),
      ChartDataPoint(
          dateTime: DateTime(2024, 05, 23),
          open: 95.87,
          high: 100.73,
          low: 95.67,
          close: 100.35),
      ChartDataPoint(
          dateTime: DateTime(2024, 05, 30),
          open: 99.6,
          high: 100.4,
          low: 96.63,
          close: 97.92),
      ChartDataPoint(
          dateTime: DateTime(2024, 06, 06),
          open: 97.99,
          high: 101.89,
          low: 97.55,
          close: 98.83),
      ChartDataPoint(
          dateTime: DateTime(2024, 06, 13),
          open: 98.69,
          high: 99.12,
          low: 95.3,
          close: 95.33),
      ChartDataPoint(
          dateTime: DateTime(2024, 06, 20),
          open: 96,
          high: 96.89,
          low: 92.65,
          close: 93.4),
      ChartDataPoint(
          dateTime: DateTime(2024, 06, 27),
          open: 93,
          high: 96.465,
          low: 91.5,
          close: 95.89),
      ChartDataPoint(
          dateTime: DateTime(2024, 07, 04),
          open: 95.39,
          high: 96.89,
          low: 94.37,
          close: 96.68),
      ChartDataPoint(
          dateTime: DateTime(2024, 07, 11),
          open: 96.75,
          high: 99.3,
          low: 96.73,
          close: 98.78),
      ChartDataPoint(
          dateTime: DateTime(2024, 07, 18),
          open: 98.7,
          high: 101,
          low: 98.31,
          close: 98.66),
      ChartDataPoint(
          dateTime: DateTime(2024, 07, 25),
          open: 98.25,
          high: 104.55,
          low: 96.42,
          close: 104.21),
      ChartDataPoint(
          dateTime: DateTime(2024, 08, 01),
          open: 104.41,
          high: 107.65,
          low: 104,
          close: 107.48),
      ChartDataPoint(
          dateTime: DateTime(2024, 08, 08),
          open: 107.52,
          high: 108.94,
          low: 107.16,
          close: 108.18),
      ChartDataPoint(
          dateTime: DateTime(2024, 08, 15),
          open: 108.14,
          high: 110.23,
          low: 108.08,
          close: 109.36),
      ChartDataPoint(
          dateTime: DateTime(2024, 08, 22),
          open: 108.86,
          high: 109.32,
          low: 106.31,
          close: 106.94),
      ChartDataPoint(
          dateTime: DateTime(2024, 08, 29),
          open: 106.62,
          high: 108,
          low: 105.5,
          close: 107.73),
      ChartDataPoint(
          dateTime: DateTime(2024, 09, 05),
          open: 107.9,
          high: 108.76,
          low: 103.13,
          close: 103.13),
      ChartDataPoint(
          dateTime: DateTime(2024, 09, 12),
          open: 102.65,
          high: 116.13,
          low: 102.53,
          close: 114.92),
      ChartDataPoint(
          dateTime: DateTime(2024, 09, 19),
          open: 115.19,
          high: 116.18,
          low: 111.55,
          close: 112.71),
      ChartDataPoint(
          dateTime: DateTime(2024, 09, 26),
          open: 111.64,
          high: 114.64,
          low: 111.55,
          close: 113.05),
      ChartDataPoint(
          dateTime: DateTime(2024, 10, 03),
          open: 112.71,
          high: 114.56,
          low: 112.28,
          close: 114.06),
      ChartDataPoint(
          dateTime: DateTime(2024, 10, 10),
          open: 115.02,
          high: 118.69,
          low: 114.72,
          close: 117.63),
      ChartDataPoint(
          dateTime: DateTime(2024, 10, 17),
          open: 117.33,
          high: 118.21,
          low: 113.8,
          close: 116.6),
      ChartDataPoint(
          dateTime: DateTime(2024, 10, 24),
          open: 117.1,
          high: 118.36,
          low: 113.31,
          close: 113.72),
      ChartDataPoint(
          dateTime: DateTime(2024, 10, 31),
          open: 113.65,
          high: 114.23,
          low: 108.11,
          close: 108.84),
      ChartDataPoint(
          dateTime: DateTime(2024, 11, 07),
          open: 110.08,
          high: 111.72,
          low: 105.83,
          close: 108.43),
      ChartDataPoint(
          dateTime: DateTime(2024, 11, 14),
          open: 107.71,
          high: 110.54,
          low: 104.08,
          close: 110.06),
      ChartDataPoint(
          dateTime: DateTime(2024, 11, 21),
          open: 114.12,
          high: 115.42,
          low: 115.42,
          close: 114.12),
      ChartDataPoint(
          dateTime: DateTime(2024, 11, 28),
          open: 111.43,
          high: 112.465,
          low: 108.85,
          close: 109.9),
      ChartDataPoint(
          dateTime: DateTime(2024, 12, 05),
          open: 110,
          high: 114.7,
          low: 108.25,
          close: 113.95),
      ChartDataPoint(
          dateTime: DateTime(2024, 12, 12),
          open: 113.29,
          high: 116.73,
          low: 112.49,
          close: 115.97),
      ChartDataPoint(
          dateTime: DateTime(2024, 12, 19),
          open: 115.8,
          high: 117.5,
          low: 115.59,
          close: 116.52),
      ChartDataPoint(
          dateTime: DateTime(2024, 12, 26),
          open: 116.52,
          high: 118.0166,
          low: 115.43,
          close: 115.82),
    ];
  }
}