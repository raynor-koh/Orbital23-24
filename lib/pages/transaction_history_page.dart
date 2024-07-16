import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robinbank_app/bloc/nav_drawer/nav_drawer_bloc.dart';
import 'package:robinbank_app/components/nav_drawer.dart';
import 'package:robinbank_app/components/transaction_card.dart';
import 'package:robinbank_app/ui/ui_text.dart';

class TransactionHistoryPage extends StatefulWidget {
  @override
  _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: FutureBuilder(
              // TODO: Add functionality to display transactions on page
              future: Future.wait(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ListView(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      scrollDirection: Axis.vertical,
                      children: snapshot.data!
                          .map((transaction) => const Text("Hello"))
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
        ),
      ],
    );
  }
}
