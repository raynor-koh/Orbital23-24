import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:robinbank_app/core/transaction/components/transaction.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';

class StockTransactionCard extends StatelessWidget {
  final Transaction transaction;

  const StockTransactionCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: UIColours.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: UIColours.background2,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  transaction.symbol,
                  style: UIText.large.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                  decoration: BoxDecoration(
                    color: transaction.isBuy ? Colors.green[200] : Colors.red[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: transaction.isBuy
                    ? Text(
                        'BUY',
                        style: UIText.small.copyWith(
                          color: UIColours.green,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        'SELL',
                        style: UIText.small.copyWith(
                          color: UIColours.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              transaction.name,
              style: UIText.small,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantity',
                      style: UIText.medium.copyWith(color: UIColours.secondaryText),
                    ),
                    Text(
                      transaction.quantity.toString(),
                      style: UIText.medium,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price per share',
                      style: UIText.medium.copyWith(color: UIColours.secondaryText),
                    ),
                    Text(
                      transaction.price.toString(),
                      style: UIText.medium,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total price',
                      style: UIText.medium.copyWith(color: UIColours.secondaryText),
                    ),
                    Text(
                      (transaction.price * transaction.quantity).toStringAsFixed(2),
                      style: UIText.medium,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${DateFormat('dd/MM/yyyy').format(transaction.timeStamp)}  ${DateFormat('HH:mm').format(transaction.timeStamp)}',
              style: UIText.small,
            ),
          ],
        ),
      ),
    );
  }
}
