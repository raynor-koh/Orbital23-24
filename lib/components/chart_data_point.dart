class ChartDataPoint {
  final DateTime? dateTime;
  final num? open;
  final num? high;
  final num? low;
  final num? close;
  // volume

  ChartDataPoint({
    this.dateTime,
    this.open,
    this.high,
    this.low,
    this.close,
  });
}