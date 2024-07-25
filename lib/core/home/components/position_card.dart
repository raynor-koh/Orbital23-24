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
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StockDetailsPage(symbol: symbol, name: name),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
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
                    const SizedBox(height: 2),
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
                      '${pnl >= 0 ? '+' : ''}${pnl.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: pnl >= 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${pnlPercentage >= 0 ? '+' : ''}${pnlPercentage.toStringAsFixed(2)}%',
                      style: UIText.xsmall.copyWith(
                        color: pnlPercentage >= 0 ? UIColours.green : UIColours.red
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
