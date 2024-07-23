import 'package:flutter/material.dart';
import 'package:robinbank_app/core/stock/charts/chart_data_point.dart';
import 'package:robinbank_app/services/alpaca_service.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class MoverChart extends StatefulWidget {
  final String symbol;

  const MoverChart({
    super.key,
    required this.symbol,
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
    _chartDataPointsFuture = alpacaService.getSparkChartDataPoints(widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChartDataPoint>>(
      future: _chartDataPointsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              width: 60,
              height: 2,
              child: LinearProgressIndicator (
                backgroundColor: UIColours.white,
                color: UIColours.blue,
              ),
            ),
          );
        } else {
          final chartDataPoints = snapshot.data!;
          final closeValues = chartDataPoints.map((point) => point.close ?? 0.0).toList();
          final isPositiveTrend = closeValues.isNotEmpty && closeValues.first < closeValues.last;
          final lineColor = isPositiveTrend ? UIColours.green : UIColours.red;
          if (chartDataPoints.length >= 2) {
            return SizedBox(
              width: 60,
              height: 40,
              child: SfSparkLineChart(
                data: closeValues,
                color: lineColor,
                width: 1.2,
                axisLineColor: Colors.transparent,
                axisLineWidth: 0,
              ),
            );
          } else {
            return SizedBox(
              width: 60,
              height: 40,
              child: Center(
                child: Text(
                  'No data',
                  style: UIText.xsmall.copyWith(color: UIColours.secondaryText),
                ),
              ),
            );
          }
        }
      },
    );
  }
}
