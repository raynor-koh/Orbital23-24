import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robinbank_app/components/candlestick_chart.dart';
import 'package:robinbank_app/models/user.dart';
import 'package:robinbank_app/providers/user_provider.dart';
import 'package:robinbank_app/services/alpaca_service.dart';
import 'package:robinbank_app/services/user_position_service.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';

class StockDetailsPage extends StatefulWidget {
  final String symbol;

  const StockDetailsPage({
    super.key,
    required this.symbol,
  });

  @override
  State<StockDetailsPage> createState() => _StockDetailsPageState();
}

class _StockDetailsPageState extends State<StockDetailsPage> {
  int quantity = 0;
  Map<String, dynamic> stockMetrics = {};
  bool isLoading = true;
  final UserPositionService userPositionService = new UserPositionService();
  final AlpacaService alpacaService = new AlpacaService();

  @override
  void initState() {
    super.initState();
    _refreshStockMetrics();
  }

  Future<void> _refreshPage() async {
    await _refreshStockMetrics();
  }

  Future<void> _refreshStockMetrics() async {
    setState(() {
      isLoading = true;
    });
    try {
      Map<String, dynamic> data =
          await alpacaService.getStockMetrics(widget.symbol);
      setState(() {
        stockMetrics = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });
    }
  }

  String formatVolume(int volume) {
    if (volume >= 1000000) {
      return '${(volume / 1000000).toStringAsFixed(1)}M';
    } else if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(1)}K';
    } else {
      return '$volume';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshPage,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildPricePanel(context),
                      const SizedBox(height: 8),
                      buildMetricsPanel(context),
                      CandlestickChart(symbol: widget.symbol),
                      const SizedBox(height: 8),
                      buildTradePanel(context),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: UIColours.lightBackground,
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.symbol, style: UIText.medium),
              Text(
                'Placeholder name',
                style: UIText.small,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPricePanel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UIColours.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(4, 8, 4, 8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stockMetrics['latestTradePrice'] != null
                  ? '\$${stockMetrics['latestTradePrice'].toStringAsFixed(2)}'
                  : 'N/A',
              style: UIText.heading,
            ),
            Row(
              children: [
                Text(
                  stockMetrics['priceDifference'] != null
                      ? '\$${stockMetrics['priceDifference'].toStringAsFixed(2)}'
                      : 'N/A',
                  style: UIText.small.copyWith(color: UIColours.red),
                ),
                const SizedBox(width: 8),
                Text(
                  stockMetrics['percentageChange'] != null
                      ? '(${stockMetrics['percentageChange'].toStringAsFixed(2)}%)'
                      : 'N/A',
                  style: UIText.small.copyWith(color: UIColours.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMetricsPanel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UIColours.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'High',
                  style: UIText.small,
                ),
                Text(
                  stockMetrics['high'] != null
                      ? '\$${stockMetrics['high']}'
                      : 'N/A',
                  style: UIText.small,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Low',
                  style: UIText.small,
                ),
                Text(
                  stockMetrics['low'] != null
                      ? '\$${stockMetrics['low']}'
                      : 'N/A',
                  style: UIText.small,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Volume',
                  style: UIText.small,
                ),
                Text(
                  stockMetrics['volume'] != null
                      ? formatVolume(stockMetrics['volume'])
                      : 'N/A',
                  style: UIText.small,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTradePanel(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).user;
    return Container(
      decoration: BoxDecoration(
        color: UIColours.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Side',
                  style: UIText.small,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Add buy functionality
                        Map<String, dynamic> payload = {
                          'symbol': stockMetrics['symbol'],
                          'name': stockMetrics['name']
                        };
                        userPositionService.executeBuyTrade(
                            context, user.id, payload);
                      },
                      child: Text(
                        'Buy',
                        style: UIText.small,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Add sell functionality
                      },
                      child: Text(
                        'Sell',
                        style: UIText.small,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quantity',
                  style: UIText.small,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: decrementQuantity,
                    ),
                    Text(
                      '$quantity',
                      style: UIText.small,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: incrementQuantity,
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Confirm Trade',
                style: UIText.small,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
