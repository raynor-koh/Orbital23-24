import 'package:flutter/material.dart';
import 'package:robinbank_app/core/stock/pages/stock_details_page.dart';
import 'package:robinbank_app/ui/ui_colours.dart';

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
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: UIColours.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300)),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    symbol,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(name,
                      style: const TextStyle(color: Colors.grey, fontSize: 12))
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
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    '$quantity',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
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
                  const SizedBox(height: 4),
                  Text(
                    '${pnlPercentage >= 0 ? '+' : ''}${pnlPercentage.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: pnlPercentage >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
