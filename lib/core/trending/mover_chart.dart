import 'package:flutter/material.dart';
import 'package:robinbank_app/core/stock/charts/chart_data_point.dart';
import 'package:robinbank_app/services/alpaca_service.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class MoverChart extends StatefulWidget {
  final String symbol;
  final bool isGradient;

  const MoverChart({
    super.key,
    required this.symbol,
    required this.isGradient,
  });

  @override
  State<MoverChart> createState() => _MoverChart();
}

class _MoverChart extends State<MoverChart> {
  final AlpacaService alpacaService = AlpacaService();
  late Future<List<ChartDataPoint>> _chartDataPointsFuture;

  @override
  void initState() {
    super.initState();
    _chartDataPointsFuture = alpacaService.getChartDataPoints(widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChartDataPoint>>(
      future: _chartDataPointsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: UIColours.white,
              color: UIColours.blue,
            ),
          );
        } else {
          final chartDataPoints = snapshot.data!;
          final isGradient = widget.isGradient;
          final isPositiveTrend = chartDataPoints.isNotEmpty && (chartDataPoints.first.close ?? 0) < (chartDataPoints.last.close ?? 0);
          final lineColor = isPositiveTrend ? UIColours.green : UIColours.red;
          final gradientColours = isPositiveTrend
              ? [Colors.green.withOpacity(0.5), Colors.green.withOpacity(0.01)]
              : [Colors.red.withOpacity(0.5), Colors.red.withOpacity(0.01)];
          return SizedBox(
            width: 80,
            height: 40,
            child: SfSparkLineChart(
              color: lineColor,
              data: const [5, 6, 5, 7, 4, 3, 9, 5, 6, 5, 7, 8, 4, 5, 3, 4, 11, 10, 2, 12, 4, 7, 6, 8],
            ),
          );
        }
      },
    );
  }
}
