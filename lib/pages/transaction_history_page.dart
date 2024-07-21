import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robinbank_app/components/transaction_card.dart';
import 'package:robinbank_app/models/transaction.dart';
import 'package:robinbank_app/providers/user_provider.dart';
import 'package:robinbank_app/services/transaction_service.dart';

class TransactionHistoryPage extends StatefulWidget {
  @override
  _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  late Future<List<Transaction>> _transactionsFuture;
  final TransactionService transactionService = TransactionService();

  @override
  void initState() {
    super.initState();
    _transactionsFuture = _loadTranscations();
  }

  Future<List<Transaction>> _loadTranscations() async {
    String userId = Provider.of<UserProvider>(context, listen: false).user.id;
    return transactionService.getUserTransactions(context, userId);
  }

  Future<void> _refreshTransactions() async {
    setState(() {
      _transactionsFuture = _loadTranscations();
    });
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<UserProvider>(context).user.id;
    _transactionsFuture =
        transactionService.getUserTransactions(context, userId);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: RefreshIndicator(
          onRefresh: _refreshTransactions,
          child: FutureBuilder(
              future: _transactionsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ListView(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      scrollDirection: Axis.vertical,
                      children: snapshot.data!
                          .map((transaction) =>
                              StockTransactionCard(transaction: transaction))
                          .toList(),
                    );
                  } else {
                    return const Center(
                        child: Text('No transactions available'));
                  }
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        )),
      ],
    );
  }
}
