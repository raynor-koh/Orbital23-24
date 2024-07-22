import 'package:flutter/material.dart';
import 'package:robinbank_app/core/stock/pages/stock_details_page.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';

class PositionCard extends StatelessWidget {
  final String symbol;
  final String name;
  final double marketValue;
  final int quantity;
  final double pnl;
  final double pnlPercentage;

  const PositionCard({
    super.key,
    required this.symbol,
    required this.name,
    required this.marketValue,
    required this.quantity,
    required this.pnl,
    required this.pnlPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = pnl >= 0;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StockDetailsPage(symbol: symbol, name: name),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          decoration: BoxDecoration(
            color: UIColours.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      symbol,
                      style: UIText.medium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: UIText.xsmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      marketValue.toStringAsFixed(2),
                      style: UIText.medium
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$quantity',
                      style: UIText.xsmall,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isPositive ? '+' : ''}${pnl.toStringAsFixed(2)}',
                      style: UIText.medium.copyWith(color: isPositive ? UIColours.green : UIColours.red),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${isPositive ? '+' : ''}${pnlPercentage.toStringAsFixed(2)}%',
                      style: UIText.xsmall.copyWith(color: isPositive ? UIColours.green : UIColours.red),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
