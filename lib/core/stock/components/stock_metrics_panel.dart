import 'package:flutter/material.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';

class StockMetricsPanel extends StatelessWidget {
  final Map<String, dynamic> stockMetrics;

  const StockMetricsPanel({
    super.key,
    required this.stockMetrics,
  });

  @override
  Widget build(BuildContext context) {
    final double dailyHigh = stockMetrics['dailyHigh'];
    final double dailyLow = stockMetrics['dailyLow'];
    final int dailyVolume = stockMetrics['dailyVolume'];
    final int dailyTrades = stockMetrics['dailyTrades'];
    final double latestTradePrice = stockMetrics['latestTradePrice'];
    final double priceDifference = stockMetrics['priceDifference'];
    final double percentageChange = stockMetrics['percentageChange'];

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
      child: Container(
        decoration: BoxDecoration(
          color: UIColours.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    latestTradePrice.toStringAsFixed(2),
                    style: UIText.heading.copyWith(
                        color: priceDifference >= 0 ? UIColours.green : UIColours.red),
                  ),
                  Row(
                    children: [
                      Text(
                        '${priceDifference >= 0 ? '+' : ''}${priceDifference.toStringAsFixed(2)}',
                        style: UIText.medium.copyWith(
                            color: priceDifference >= 0
                                ? UIColours.green
                                : UIColours.red),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${percentageChange >= 0 ? '+' : ''}${percentageChange.toStringAsFixed(2)}%',
                        style: UIText.medium.copyWith(
                            color: priceDifference >= 0
                                ? UIColours.green
                                : UIColours.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
              child: SizedBox(
                width: 160,
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'H/L',
                          style: UIText.small,
                        ),
                        Text(
                          '$dailyHigh - $dailyLow',
                          style: UIText.small,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Vol',
                          style: UIText.small,
                        ),
                        Text(
                          _formatNumbers(dailyVolume),
                          style: UIText.small,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Trades',
                          style: UIText.small,
                        ),
                        Text(
                          _formatNumbers(dailyTrades),
                          style: UIText.small,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumbers(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return '$number';
    }
  }
}