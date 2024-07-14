import 'package:flutter/material.dart';
import 'package:robinbank_app/components/transaction_card.dart';
import 'package:robinbank_app/components/transaction_widget.dart';

class TestPage3 extends StatelessWidget {
  const TestPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: sendRequest(context),
        builder: (context, snapshot) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TransactionCard(
                  symbol: "AAPL",
                  name: "Apple Inc. Common Stock",
                  quantity: 100,
                  price: 100,
                  buyBool: true,
                  timeStamp: DateTime.now(),
                ),
                StockTransactionWidget(
                  symbol: "APPL",
                  companyName: "Apple Inc. Common Stock",
                  quantity: 100,
                  price: 100,
                  transactionTime: DateTime.now(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> sendRequest(BuildContext context) async {}
}
