import 'package:flutter/material.dart';
import 'package:robinbank_app/core/stock/charts/chart_data_point.dart';
import 'package:robinbank_app/core/stock/charts/custom_trackball_behaviour.dart';
import 'package:robinbank_app/core/stock/charts/custom_x_axis.dart';
import 'package:robinbank_app/core/stock/charts/custom_y_axis.dart';
import 'package:robinbank_app/core/stock/charts/custom_zoom_pan_behaviour.dart';
import 'package:robinbank_app/services/alpaca_service.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CandleChart extends StatefulWidget {
  final String symbol;
  final bool isHollowCandle;

  const CandleChart({
    super.key,
    required this.symbol,
    required this.isHollowCandle,
  });

  @override
  State<CandleChart> createState() => _CandlestickChartState();
}

class _CandlestickChartState extends State<CandleChart> {
  final AlpacaService alpacaService = AlpacaService();
  late Future<List<ChartDataPoint>> _chartDataPointsFuture;
  late TrackballBehavior _trackballBehaviour;
  late ZoomPanBehavior _zoomPanBehaviour;

  @override
  void initState() {
    super.initState();
    _chartDataPointsFuture = alpacaService.getChartDataPoints(widget.symbol);
    _trackballBehaviour = CustomTrackballBehaviour.create(
      tooltipFormat: 'point.x\nOpen: point.open\nHigh: point.high\nLow: point.low\nClose: point.close',
      isMarkerVisible: false,
    );
    _zoomPanBehaviour = CustomZoomPanBehaviour.create();
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
        } else {
          final chartDataPoints = snapshot.data!;
          final bool isHollowCandle = widget.isHollowCandle;
          return Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: SfCartesianChart(
                  backgroundColor: UIColours.background1,
                  borderColor: UIColours.background2,
                  borderWidth: 1,
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
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
                      enableTooltip: true,
                      enableSolidCandles: !isHollowCandle,
                      bearColor: Colors.red,
                      bullColor: Colors.green,
                      borderWidth: 1.5,
                      animationDuration: 500,
                      // trendlines: chartDataPoints.isNotEmpty ? [
                      //   Trendline(
                      //     type: TrendlineType.movingAverage,
                      //     width: 1,
                      //     color: UIColours.blue,
                      //     opacity: 0.7,
                      //   ),
                      // ] : [],
                    ),
                  ],
                  primaryXAxis: CustomXAxis.create(autoScrollingDelta: 50),
                  primaryYAxis: CustomYAxis.create(),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
