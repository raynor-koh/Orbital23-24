import 'package:flutter/material.dart';
import 'package:robinbank_app/core/trending/mover_chart.dart';
import 'package:robinbank_app/ui/ui_text.dart';
import 'package:robinbank_app/ui/ui_colours.dart';

class MoverCard extends StatelessWidget {
  final Map<String, dynamic> stock;
  final String category;

  const MoverCard({
    super.key,
    required this.stock,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stock['symbol'],
                  style: UIText.medium.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  stock['name'] ?? 'placeholder',
                  style: UIText.small.copyWith(color: UIColours.secondaryText),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          MoverChart(symbol: stock['symbol'], isGradient: false),
          SizedBox(width: 40),
          _buildMetricDisplay(),
        ],
      ),
    );
  }

  Widget _buildMetricDisplay() {
    if (category == 'Most Active') {
      final volume = stock['volume'];
      return Text(
        _formatNumbers(volume),
        style: UIText.medium,
      );
    } else {
      final percentageChange = stock['percentageChange'];
      final isPositive = percentageChange > 0;
      return Text(
        '${isPositive ? '+' : ''}${percentageChange.toStringAsFixed(2)}',
        style: UIText.medium.copyWith(color: isPositive ? UIColours.green : UIColours.red,),
      );
    }
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
