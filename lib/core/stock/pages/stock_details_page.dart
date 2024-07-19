import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robinbank_app/core/stock/components/candle_chart.dart';
import 'package:robinbank_app/core/stock/charts/chart_type.dart';
import 'package:robinbank_app/core/stock/components/line_chart.dart';
import 'package:robinbank_app/core/stock/components/news_article.dart';
import 'package:robinbank_app/models/user.dart';
import 'package:robinbank_app/providers/user_provider.dart';
import 'package:robinbank_app/services/alpaca_service.dart';
import 'package:robinbank_app/services/user_position_service.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';
import 'package:url_launcher/url_launcher.dart';
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
  bool isPageLoading = true;

  final UserPositionService userPositionService = UserPositionService();
  final AlpacaService alpacaService = AlpacaService();
  
  Map<String, dynamic> stockMetrics = {};
  List<NewsArticle> newsArticles = [];

  bool isMarketOpen = false;
  ChartType selectedChartType = ChartType.line;
  
  bool isBuy = true;
  int quantity = 1;
  List<bool> selectedSide = [true, false];

  @override
  void initState() {
    super.initState();
    _refreshPage();
  }

  Future<void> _refreshPage() async {
    await Future.wait([
      _refreshStockMetrics(),
      _refreshNewsArticles(),
    ]);
  }

  Future<void> _refreshStockMetrics() async {
    setState(() {
      isPageLoading = true;
    });
    try {
      Map<String, dynamic> data = await alpacaService.getStockMetrics(widget.symbol);
      setState(() {
        stockMetrics = data;
        isMarketOpen = data['latestTradePrice'] != null;
        isPageLoading = false;
      });
    } catch (e) {
      setState(() {
        isPageLoading = false;
      });
    }
  }

  Future<void> _refreshNewsArticles() async {
    setState(() {
      isPageLoading = true;
    });
    try {
      List<NewsArticle> data = await alpacaService.getNewsArticles(widget.symbol);
      setState(() {
        newsArticles = data;
        isPageLoading = false;
      });
    } catch (e) {
      setState(() {
        isPageLoading = false;
      });
    }
  }

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  String formatNumbers(int volume) {
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
      body: isPageLoading
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
                    children: [
                      buildMetricsPanel(context),
                      const SizedBox(height: 4),
                      buildChartTypeToggle(),
                      const SizedBox(height: 4),
                      buildSelectedChartType(),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.symbol,
                style: UIText.large.copyWith(color: UIColours.white)
              ),
              Text(
                widget.name,
                style: UIText.small.copyWith(color: UIColours.white),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.newspaper,
            color: UIColours.white,
            size: 28,
          ),
          onPressed: () => _showLatestStoriesDialogue(context),
        ),
      ],
    );
  }

  Widget buildMetricsPanel(BuildContext context) {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    latestTradePrice.toStringAsFixed(2) ?? 'N/A',
                    style: UIText.heading.copyWith(
                        color: priceDifference >= 0 ? UIColours.green : UIColours.red),
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
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
              child: SizedBox(
                width: 140,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'H/L',
                          style: UIText.small,
                        ),
                        Text(
                          stockMetrics['high'] != null && stockMetrics['low'] != null
                              ? '${stockMetrics['high']} - ${stockMetrics['low']}'
                              : 'N/A',
                          style: UIText.small,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Vol',
                          style: UIText.small,
                        ),
                        Text(
                          stockMetrics['volume'] != null
                              ? formatNumbers(stockMetrics['volume'])
                              : 'N/A',
                          style: UIText.small,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Trades',
                          style: UIText.small,
                        ),
                        Text(
                          stockMetrics['numOfTrades'] != null
                              ? formatNumbers(stockMetrics['numOfTrades'])
                              : 'N/A',
                          style: UIText.small,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLatestStoriesDialogue(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: UIColours.background1,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Latest Stories',
            style: UIText.heading,
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 500,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: newsArticles.length,
              itemBuilder: (BuildContext context, int index) {
                return buildNewsArticle(newsArticles[index]);
              },
            ),
          ),
          titlePadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        );
      },
    );
  }

  Widget buildNewsArticle(NewsArticle article) {
    return Container(
      color: UIColours.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Container(
          constraints: BoxConstraints(maxWidth: 300), // Adjust width as needed
          child: Text(
            article.headline,
            style: UIText.small,
            overflow: TextOverflow.ellipsis,
            maxLines: 2, // Limit number of lines
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'By ${article.author} on ${article.updatedAt}',
          style: UIText.xsmall,
          overflow: TextOverflow.ellipsis, // Handle overflow for the author/date
        ),
        const SizedBox(height: 2),
        GestureDetector(
          onTap: () => _launchURL(article.url),
          child: Text(
            'Read more',
            style: UIText.xsmall.copyWith(color: UIColours.blue),
          ),
        ),
        const Divider(),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
   if (!await launchUrl(Uri.parse(url))) {
        throw Exception('Could not launch url');
    }
  }

  Widget buildChartTypeToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                selectedChartType = ChartType.line;
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: selectedChartType == ChartType.line ? UIColours.blue : null,
              // primary: selectedChartType == ChartType.line ? Colors.white : null,
            ),
            child: Text('Line'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                selectedChartType = ChartType.area;
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: selectedChartType == ChartType.area ? UIColours.blue : null,
              // primary: selectedChartType == ChartType.area ? Colors.white : null,
            ),
            child: Text('Area'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                selectedChartType = ChartType.candle;
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: selectedChartType == ChartType.candle ? UIColours.blue : null,
              // primary: selectedChartType == ChartType.candle ? Colors.white : null,
            ),
            child: Text('Candle'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                selectedChartType = ChartType.hollowCandle;
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: selectedChartType == ChartType.hollowCandle ? UIColours.blue : null,
              // primary: selectedChartType == ChartType.hollowCandle ? Colors.white : null,
            ),
            child: Text('Hollow Candle'),
          ),
        ],
      ),
    );
  }

  Widget buildSelectedChartType() {
    switch (selectedChartType) {
      case ChartType.line:
        return LineChart(symbol: widget.symbol, isGradient: true);
      case ChartType.area:
        return LineChart(symbol: widget.symbol, isGradient: false);
      case ChartType.candle:
        return CandleChart(symbol: widget.symbol, isHollowCandle: false);
      case ChartType.hollowCandle:
        return CandleChart(symbol: widget.symbol, isHollowCandle: true);
      default:
        return Container();
    }
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
                  selectedBorderColor: isBuy ? Colors.green[700] : Colors.red[700],
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
                      onPressed: _incrementQuantity,
                    ),
                    Text(
                      '$quantity',
                      style: UIText.small,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _decrementQuantity,
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
                    if (!isMarketOpen) {
                      showSnackBar(context, "Market is closed!");
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
