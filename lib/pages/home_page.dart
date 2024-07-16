import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robinbank_app/components/stock_card.dart';
import 'package:robinbank_app/models/account_position.dart';
import 'package:robinbank_app/models/user.dart';
import 'package:robinbank_app/models/user_position.dart';
import 'package:robinbank_app/pages/transaction_history_page.dart';
import 'package:robinbank_app/providers/user_position_provider.dart';
import 'package:robinbank_app/providers/user_provider.dart';
import 'package:robinbank_app/services/alpaca_service.dart';
import 'package:robinbank_app/services/user_position_service.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserPositionService userPositionService = UserPositionService();
  final AlpacaService alpacaService = AlpacaService();

  @override
  void initState() {
    super.initState();
    String userId = Provider.of<UserProvider>(context, listen: false).user.id;
    userPositionService.getUserPosition(context, userId);
  }

  @override
  Widget build(BuildContext context) {
    List<AccountPosition> userAccountPosition =
        Provider.of<UserPositionProvider>(context)
            .userPosition
            .accountPositions;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 8,
          ),
          buildStatisticsPanel(context),
          const SizedBox(
            height: 4,
          ),
          buildIconButtonsPanel(context),
          const SizedBox(
            height: 4,
          ),
          Align(
            alignment: const AlignmentDirectional(-1, 0),
            child: Text(
              'Your Position(s)',
              style: UIText.medium,
            ),
          ),
          Expanded(
            child: FutureBuilder(future: Future.wait(
              userAccountPosition.map(
                (position) async {
                  Map<String, dynamic> stockMetrics =
                      await alpacaService.getStockMetrics(position.symbol);
                  double marketValue =
                      stockMetrics['latestTradePrice'] * position.quantity;
                  num initialInvestment =
                      position.price * (position.quantity.toDouble());
                  double pnl = marketValue - initialInvestment;
                  double pnlPercentage = pnl / initialInvestment * 100;
                  return StockCard(
                    symbol: position.symbol,
                    name: position.name,
                    marketValue: marketValue,
                    quantity: position.quantity,
                    pnl: pnl,
                    pnlPercentage: pnlPercentage,
                  );
                },
              ),
            ), builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return ListView(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    scrollDirection: Axis.vertical,
                    children:
                        snapshot.data!.map((stockCard) => stockCard).toList(),
                  );
                } else {
                  return const Center(child: Text('No positions available'));
                }
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
          )
        ],
      ),
    );
  }

  Widget buildStatisticsPanel(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    UserPosition userPosition =
        Provider.of<UserPositionProvider>(context).userPosition;
    return Container(
      decoration: BoxDecoration(
        color: UIColours.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 16, 8, 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Net Account Value',
              style: UIText.small.copyWith(color: UIColours.secondaryText),
            ),
            Text(
              userPosition.accountBalance.toStringAsFixed(2),
              style: UIText.heading,
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Market Value',
                      style:
                          UIText.small.copyWith(color: UIColours.secondaryText),
                    ),
                    Text(
                      '8,794.40',
                      style: UIText.medium,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Buying Power',
                      style:
                          UIText.small.copyWith(color: UIColours.secondaryText),
                    ),
                    Text(
                      userPosition.buyingPower.toStringAsFixed(2),
                      style: UIText.medium,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Day\'s P&L',
                      style:
                          UIText.small.copyWith(color: UIColours.secondaryText),
                    ),
                    Text(
                      '-18.40',
                      style: UIText.medium.copyWith(color: UIColours.red),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIconButtonsPanel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UIColours.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.candlestick_chart_outlined,
                    size: 32,
                    color: UIColours.blue,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/searchpage');
                  },
                ),
                Text(
                  'Trade',
                  style: UIText.small,
                ),
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.receipt_long_outlined,
                    size: 32,
                    color: UIColours.blue,
                  ),
                  onPressed: () {},
                ),
                Text(
                  'Transactions',
                  style: UIText.small,
                ),
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.analytics_outlined,
                    size: 32,
                    color: UIColours.blue,
                  ),
                  onPressed: () {},
                ),
                Text(
                  'Performance',
                  style: UIText.small,
                  softWrap: true,
                ),
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.restart_alt_outlined,
                    size: 32,
                    color: UIColours.blue,
                  ),
                  onPressed: () {
                    _showResetAccountDialogue(context);
                  },
                ),
                Text(
                  'Reset',
                  style: UIText.small,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showResetAccountDialogue(BuildContext context) async {
    double? newBalance;
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: const Text('Reset Account Balance'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Enter new starting balance:'),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "New Balance"),
                  onChanged: (value) {
                    newBalance = double.tryParse(value);
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                if (newBalance != null) {
                  _confirmReset(context, newBalance!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid number'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmReset(BuildContext context, double newBalance) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Reset'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Are you sure you want to reset your account?'),
                Text('New Balance: \$${newBalance.toStringAsFixed(2)}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetAccountBalance(context, newBalance);
              },
            ),
          ],
        );
      },
    );
  }

  void _resetAccountBalance(BuildContext context, double newBalance) {
    String userId = Provider.of<UserProvider>(context, listen: false).user.id;
    // Update the user account balance in the provider
    userPositionService.resetUserPosition(context, userId, newBalance);
    userPositionService.getUserPosition(context, userId);

    // Display a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Account balance reset to \$${newBalance.toStringAsFixed(2)}'),
      ),
    );

    // Close the confirmation dialog
    Navigator.of(context).pop();
  }
}
