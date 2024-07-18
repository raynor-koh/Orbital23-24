import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:robinbank_app/components/chart_data_point.dart';
import 'package:robinbank_app/services/alpaca_service.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChart extends StatefulWidget {
  final String symbol;
  final isArea;

  const LineChart({
    super.key,
    required this.symbol,
    required this.isArea,
  });

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
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
      tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
      tooltipSettings: InteractiveTooltip(
        enable: true,
        canShowMarker: false,
        color: UIColours.white,
        borderWidth: 0.0,
        borderRadius: 4,
        borderColor: Colors.transparent,
        textStyle: UIText.xsmall,
        format: 'point.x\nClose: point.y',
      ),
      markerSettings: const TrackballMarkerSettings(
        markerVisibility: TrackballVisibilityMode.visible,
        height: 8,
        width: 8,
        borderWidth: 0,
        borderColor: Colors.transparent,
        color: UIColours.blue
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
          final isArea = widget.isArea;
          final isPositiveTrend = (chartDataPoints.first.close ?? 0) < (chartDataPoints.last.close ?? 0);
          final lineColor = isPositiveTrend ? Colors.green : Colors.red;
          final gradientColours = isPositiveTrend
              ? [Colors.green.withOpacity(0.5), Colors.green.withOpacity(0.01)]
              : [Colors.red.withOpacity(0.5), Colors.red.withOpacity(0.01)];
          return Column(
            children: [
              SizedBox(
                height: 270,
                child: SfCartesianChart(
                  backgroundColor: UIColours.background1,
                  borderColor: UIColours.background2,
                  borderWidth: 1,
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  plotAreaBorderWidth: 0.0,
                  trackballBehavior: _trackballBehaviour,
                  zoomPanBehavior: _zoomPanBehaviour,
                  series: isArea
                  ? [
                    LineSeries<ChartDataPoint, DateTime>(
                      dataSource: chartDataPoints,
                      xValueMapper: (ChartDataPoint point, _) => point.dateTime,
                      yValueMapper: (ChartDataPoint point, _) => point.close,
                      enableTooltip: true,
                      color: lineColor,
                      width: 2,
                      animationDuration: 500,
                    ),
                    AreaSeries<ChartDataPoint, DateTime>(
                      dataSource: chartDataPoints,
                      xValueMapper: (ChartDataPoint point, _) => point.dateTime,
                      yValueMapper: (ChartDataPoint point, _) => point.close,
                      enableTooltip: false,
                      onCreateShader: (ShaderDetails details) {
                        return ui.Gradient.linear(
                          details.rect.topCenter,
                          details.rect.bottomCenter,
                          gradientColours);
                      },
                      animationDuration: 500,
                    ),
                  ]
                  : [
                    LineSeries<ChartDataPoint, DateTime>(
                      dataSource: chartDataPoints,
                      xValueMapper: (ChartDataPoint point, _) => point.dateTime,
                      yValueMapper: (ChartDataPoint point, _) => point.close,
                      enableTooltip: true,
                      color: lineColor,
                      width: 2,
                      animationDuration: 500,
                    ),
                  ],
                  primaryXAxis: DateTimeAxis(
                    dateFormat: DateFormat('HH.mm'),
                    autoScrollingDelta: 70,
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
                  ),
                  primaryYAxis: const NumericAxis(
                    anchorRangeToVisiblePoints: true,
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
