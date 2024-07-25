import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robinbank_app/core/home/components/position_card.dart';
import 'package:robinbank_app/models/account_position.dart';
import 'package:robinbank_app/models/user_position.dart';
import 'package:robinbank_app/providers/user_position_provider.dart';
import 'package:robinbank_app/providers/user_provider.dart';
import 'package:robinbank_app/services/alpaca_service.dart';
import 'package:robinbank_app/services/transaction_service.dart';
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
  final TransactionService transactionService = TransactionService();

  late Future<Map<String, dynamic>> _portfolioDataFuture;

  @override
  void initState() {
    super.initState();
    // String userId = Provider.of<UserProvider>(context, listen: false).user.id;
    // userPositionService.getUserPosition(context, userId);
    // _portfolioDataFuture = _fetchPortfolioData(userId);
    _initializeData();
  }

  void _initializeData() {
    String userId = Provider.of<UserProvider>(context, listen: false).user.id;
    _portfolioDataFuture = _fetchPortfolioData(userId);
  }

  Future<void> _refreshData() async {
    setState(() {
      _initializeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<Map<String, dynamic>>(
          future: _portfolioDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            } else {
              final data = snapshot.data!;
              return _builHomePageContent(data);
            }
          },
        ));
  }

  Widget _builHomePageContent(Map<String, dynamic> data) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            buildStatisticsPanel(context, data),
            const SizedBox(height: 4),
            buildIconButtonsPanel(context),
            const SizedBox(height: 4),
            Align(
              alignment: const AlignmentDirectional(-1, 0),
              child: Text(
                'Your Position(s)',
                style: UIText.medium,
              ),
            ),
            data['stockCards'].isEmpty
                ? const Center(child: Text('No positions available'))
                : ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    children: data['stockCards'],
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildStatisticsPanel(BuildContext context, Map<String, dynamic> data) {
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
              'Net Account Value (USD)',
              style: UIText.small.copyWith(color: UIColours.secondaryText),
            ),
            Text(
              data['netAccountValue'].toStringAsFixed(2),
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
                      data['marketValue'].toStringAsFixed(2),
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
                      data['buyingPower'].toStringAsFixed(2),
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
                      data['daysPnL'] > 0
                          ? '+${data['daysPnL'].toStringAsFixed(2)}'
                          : data['daysPnL'].toStringAsFixed(2),
                      style: data['daysPnL'] == 0
                          ? UIText.medium.copyWith()
                          : data['daysPnL'] < 0
                              ? UIText.medium.copyWith(color: UIColours.red)
                              : UIText.medium.copyWith(color: UIColours.green),
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
                  'Orders',
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/marketmoverspage');
                  },
                ),
                Text(
                  'Trending',
                  style: UIText.small,
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
                    _showResetBalanceDialogue(context);
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

  Future<void> _showResetBalanceDialogue(BuildContext context) async {
    double? newBalance;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: UIColours.background1,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  'Reset Starting Balance',
                  style: UIText.large,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "New Balance",
                    hintStyle:
                        UIText.small.copyWith(color: UIColours.secondaryText),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: UIColours.secondaryText,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: UIColours.blue,
                        width: 1.5,
                      ),
                    ),
                  ),
                  textAlignVertical: TextAlignVertical.bottom,
                  onChanged: (value) {
                    newBalance = double.tryParse(value);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: UIText.small,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Confirm',
                style: UIText.small.copyWith(color: UIColours.blue),
              ),
              onPressed: () {
                if (newBalance != null) {
                  _showConfirmResetBalanceDiagloue(context, newBalance!);
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

  Future<void> _showConfirmResetBalanceDiagloue(
      BuildContext context, double newBalance) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: UIColours.white,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Reset',
            style: UIText.large.copyWith(color: UIColours.red),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  'All your positions will be erased and your balance will be set to ${newBalance.toStringAsFixed(2)}',
                  style: UIText.small,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Are you sure to proceed?',
                  style: UIText.small,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: UIText.small,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Confirm',
                style: UIText.small.copyWith(color: UIColours.blue),
              ),
              onPressed: () {
                _resetBalance(context, newBalance);
                Navigator.of(context).pushNamed("/mainwrapper");
              },
            ),
          ],
        );
      },
    );
  }

  void _resetBalance(BuildContext context, double newBalance) {
    String userId = Provider.of<UserProvider>(context, listen: false).user.id;
    userPositionService.resetUserPosition(context, userId, newBalance);
    userPositionService.getUserPosition(context, userId);
    transactionService.resetTransactions(context, userId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Balance has been reset'),
      ),
    );

    Navigator.of(context).pop();
  }

  Future<Map<String, dynamic>> _fetchPortfolioData(String userId) async {
    await userPositionService.getUserPosition(context, userId);
    UserPosition userPosition =
        Provider.of<UserPositionProvider>(context, listen: false).userPosition;
    List<AccountPosition> positions = userPosition.accountPositions;

    double totalMarketValue = 0;
    double totalPnL = 0;
    List<PositionCard> stockCards = [];

    for (var position in positions) {
      Map<String, dynamic> stockMetrics =
          await alpacaService.getStockMetrics(position.symbol);
      double currentPrice = stockMetrics['latestTradePrice'];
      double marketValue = currentPrice * position.quantity;
      double pnl = marketValue - (position.price * position.quantity);
      double pnlPercentage = (pnl / (position.price * position.quantity)) * 100;

      totalMarketValue += marketValue;
      totalPnL += pnl;

      stockCards.add(PositionCard(
        symbol: position.symbol,
        name: position.name,
        marketValue: marketValue,
        quantity: position.quantity,
        pnl: pnl,
        pnlPercentage: pnlPercentage,
      ));
    }

    double netAccountValue = userPosition.buyingPower + totalMarketValue;
    double buyingPower = userPosition.buyingPower + 0;

    return {
      'netAccountValue': netAccountValue,
      'marketValue': totalMarketValue,
      'buyingPower': buyingPower,
      'daysPnL': totalPnL,
      'stockCards': stockCards,
    };
  }
}
