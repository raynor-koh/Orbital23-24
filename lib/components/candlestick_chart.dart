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
    return FutureBuilder<List<ChartDataPoint>>(
      future: _chartDataPointsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final chartDataPoints = snapshot.data!;
          return SizedBox(
            height: 200,
            child: SfCartesianChart(
              trackballBehavior: _trackballBehaviour,
              zoomPanBehavior: _zoomPanBehaviour,
              series: <CandleSeries>[
                CandleSeries<ChartDataPoint, DateTime>(
                  dataSource: chartDataPoints,
                  xValueMapper: (ChartDataPoint point, _) => point.dateTime,
                  openValueMapper: (ChartDataPoint point, _) => point.open,
                  highValueMapper: (ChartDataPoint point, _) => point.high,
                  lowValueMapper: (ChartDataPoint point, _) => point.low,
                  closeValueMapper: (ChartDataPoint point, _) => point.close,
                ),
              ],
              primaryXAxis: DateTimeAxis(
                dateFormat: DateFormat('MM/dd HH.mm'),
                autoScrollingDelta: 1,
                autoScrollingMode: AutoScrollingMode.end,
                majorGridLines: const MajorGridLines(width: 0),
                isVisible: false,
              ),
              primaryYAxis: const NumericAxis(
                isVisible: false,
              ),
            ),
          );
        }
      },
    );
  }
}
