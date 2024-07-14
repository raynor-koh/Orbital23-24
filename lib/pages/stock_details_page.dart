import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robinbank_app/components/candlestick_chart.dart';
import 'package:robinbank_app/models/user.dart';
import 'package:robinbank_app/providers/user_provider.dart';
import 'package:robinbank_app/services/alpaca_service.dart';
import 'package:robinbank_app/services/user_position_service.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';
import 'package:robinbank_app/utils/utils.dart';

class StockDetailsPage extends StatefulWidget {
  final String symbol;
  final String name;

  const StockDetailsPage({
    super.key,
    required this.symbol,
    required this.name,
  });

  @override
  State<StockDetailsPage> createState() => _StockDetailsPageState();
}

class _StockDetailsPageState extends State<StockDetailsPage> {
  Map<String, dynamic> stockMetrics = {};
  bool isLoading = true;
  final UserPositionService userPositionService = UserPositionService();
  final AlpacaService alpacaService = AlpacaService();
  int quantity = 1;
  bool isBuy = true;
  bool marketOpen = false;
  List<bool> selectedSide = [true, false];

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
        marketOpen = data['latestTraderPrice'] != null;
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
    if (quantity > 1) {
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
          ? const Center(
              child: RefreshProgressIndicator(
                backgroundColor: UIColours.white,
                color: UIColours.blue,
              ),
            )
          : RefreshIndicator(
              backgroundColor: UIColours.white,
              color: UIColours.blue,
              onRefresh: _refreshPage,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildPricePanel(context),
                      const SizedBox(height: 4),
                      buildMetricsPanel(context),
                      const SizedBox(height: 4),
                      CandlestickChart(symbol: widget.symbol),
                      const SizedBox(height: 4),
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
      backgroundColor: UIColours.blue,
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: UIColours.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.symbol,
                  style: UIText.large.copyWith(color: UIColours.white)),
              Text(
                widget.name,
                style: UIText.small.copyWith(color: UIColours.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPricePanel(BuildContext context) {
    final latestTradePrice = stockMetrics['latestTradePrice'];
    final priceDifference = stockMetrics['priceDifference'];
    final percentageChange = stockMetrics['percentageChange'];

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
      child: Container(
        decoration: BoxDecoration(
          color: UIColours.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                latestTradePrice.toStringAsFixed(2) ?? 'N/A',
                style: UIText.heading.copyWith(
                    color:
                        priceDifference >= 0 ? UIColours.green : UIColours.red),
              ),
              Row(
                children: [
                  Text(
                    '${priceDifference >= 0 ? '+' : ''}${priceDifference.toStringAsFixed(2) ?? 'N/A'}',
                    style: UIText.medium.copyWith(
                        color: priceDifference >= 0
                            ? UIColours.green
                            : UIColours.red),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${percentageChange >= 0 ? '+' : ''}${percentageChange.toStringAsFixed(2)}%',
                    style: UIText.medium.copyWith(
                        color: priceDifference >= 0
                            ? UIColours.green
                            : UIColours.red),
                  ),
                ],
              ),
            ],
          ),
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
                      ? '${stockMetrics['high']}'
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
                      ? '${stockMetrics['low']}'
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
                ToggleButtons(
                  isSelected: selectedSide,
                  borderWidth: 1,
                  borderRadius: BorderRadius.circular(4),
                  selectedColor: Colors.white,
                  selectedBorderColor:
                      isBuy ? Colors.green[700] : Colors.red[700],
                  fillColor: isBuy ? Colors.green[200] : Colors.red[200],
                  constraints: const BoxConstraints(
                    minHeight: 30.0,
                    minWidth: 80.0,
                  ),
                  children: [
                    Text(
                      'Buy',
                      style: UIText.small,
                    ),
                    Text(
                      'Sell',
                      style: UIText.small,
                    ),
                  ],
                  onPressed: (int index) {
                    setState(() {
                      isBuy = index == 0;
                      for (int i = 0; i < selectedSide.length; i++) {
                        selectedSide[i] = i == index;
                      }
                    });
                  },
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
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (!marketOpen) {
                      showSnackBar(context, "Market is not open currently.");
                      return;
                    }
                    Map<String, dynamic> payload = {
                      'symbol': widget.symbol,
                      'name': widget.name,
                      'quantity': quantity,
                      'price': stockMetrics['latestTradePrice'],
                      // 'price': 100,
                    };
                    if (isBuy) {
                      await userPositionService.executeBuyTrade(
                          context, user.id, payload);
                    } else {
                      await userPositionService.executeSellTrade(
                          context, user.id, payload);
                    }
                    Navigator.of(context).pushNamed("/mainwrapper");
                  },
                  child: Text(
                    'Confirm Trade',
                    style: UIText.small,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/mainwrapper");
                  },
                  child: Text(
                    "Return Home",
                    style: UIText.small,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
