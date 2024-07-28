import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:robinbank_app/core/stock/charts/chart_data_point.dart';
import 'package:robinbank_app/core/stock/charts/custom_trackball_behaviour.dart';
import 'package:robinbank_app/core/stock/charts/custom_x_axis.dart';
import 'package:robinbank_app/core/stock/charts/custom_y_axis.dart';
import 'package:robinbank_app/core/stock/charts/custom_zoom_pan_behaviour.dart';
import 'package:robinbank_app/services/alpaca_service.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChart extends StatefulWidget {
  final String symbol;
  final bool isGradient;

  const LineChart({
    super.key,
    required this.symbol,
    required this.isGradient,
  });

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  final AlpacaService alpacaService = AlpacaService();
  late Future<List<ChartDataPoint>> _chartDataPointsFuture;
  late TrackballBehavior _trackballBehaviour;
  late ZoomPanBehavior _zoomPanBehaviour;

  @override
  void initState() {
    super.initState();
    _chartDataPointsFuture = alpacaService.getChartDataPoints(widget.symbol);
    _trackballBehaviour = CustomTrackballBehaviour.create(
      tooltipFormat: 'point.x UTC\nClose: point.y',
      isMarkerVisible: true,
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
          final isGradient = widget.isGradient;
          final isPositiveTrend = chartDataPoints.isNotEmpty && (chartDataPoints.first.close ?? 0) < (chartDataPoints.last.close ?? 0);
          final lineColour = isGradient
            ? isPositiveTrend ? UIColours.green : UIColours.red 
            : Colors.transparent;
          final areaColour = isGradient
            ? null
            : isPositiveTrend ? UIColours.green.withOpacity(0.7) : UIColours.red.withOpacity(0.7);
          final gradientColours = isPositiveTrend
              ? [Colors.green.withOpacity(0.5), Colors.green.withOpacity(0.01)]
              : [Colors.red.withOpacity(0.5), Colors.red.withOpacity(0.01)];
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
                    LineSeries<ChartDataPoint, DateTime>(
                      dataSource: chartDataPoints,
                      xValueMapper: (ChartDataPoint point, _) => point.dateTime,
                      yValueMapper: (ChartDataPoint point, _) => point.close,
                      enableTooltip: true,
                      color: lineColour,
                      width: 1,
                      animationDuration: 500,
                    ),
                    AreaSeries<ChartDataPoint, DateTime>(
                      dataSource: chartDataPoints,
                      xValueMapper: (ChartDataPoint point, _) => point.dateTime,
                      yValueMapper: (ChartDataPoint point, _) => point.close,
                      enableTooltip: false,
                      onCreateShader: isGradient
                        ? (ShaderDetails details) {
                            return ui.Gradient.linear(
                              details.rect.topCenter,
                              details.rect.bottomCenter,
                              gradientColours,
                            );
                          }
                        : null,
                      color: areaColour,
                      animationDuration: 500,
                    ),
                  ],
                  primaryXAxis: CustomXAxis.create(autoScrollingDelta: 70),
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
