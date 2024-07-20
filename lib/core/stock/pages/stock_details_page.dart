import 'package:flutter/material.dart';
import 'package:robinbank_app/core/stock/components/candle_chart.dart';
import 'package:robinbank_app/core/stock/charts/chart_type.dart';
import 'package:robinbank_app/core/stock/components/line_chart.dart';
import 'package:robinbank_app/core/stock/components/news_article.dart';
import 'package:robinbank_app/core/stock/components/stock_metrics_panel.dart';
import 'package:robinbank_app/core/stock/components/trade_panel.dart';
import 'package:robinbank_app/services/alpaca_service.dart';
import 'package:robinbank_app/services/user_position_service.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final AlpacaService _alpacaService = AlpacaService();

  bool _isLoading = true;
  Map<String, dynamic> _stockMetrics = {};
  List<NewsArticle> _newsArticles = [];

  ChartType selectedChartType = ChartType.line;
  final UserPositionService userPositionService = UserPositionService();

  @override
  void initState() {
    super.initState();
    _loadStates();
  }

  Future<void> _loadStates() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final stockMetrics = await _alpacaService.getStockMetrics(widget.symbol);
      final newsArticles = await _alpacaService.getNewsArticles(widget.symbol);
      setState(() {
        _stockMetrics = stockMetrics;
        _newsArticles = newsArticles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _isLoading
          ? const Center(
              child: RefreshProgressIndicator(
                backgroundColor: UIColours.white,
                color: UIColours.blue,
              ),
            )
          : RefreshIndicator(
              backgroundColor: UIColours.white,
              color: UIColours.blue,
              onRefresh: _loadStates,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      StockMetricsPanel(
                        stockMetrics: _stockMetrics
                      ),
                      const SizedBox(height: 4),
                      buildChartTypeToggle(),
                      const SizedBox(height: 4),
                      buildSelectedChartType(),
                      const SizedBox(height: 4),
                      TradePanel(
                        symbol: widget.symbol,
                        name: widget.name,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 8,
      backgroundColor: UIColours.blue,
      title: Row(
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
                style: UIText.large.copyWith(color: UIColours.white),
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
              itemCount: _newsArticles.length,
              itemBuilder: (BuildContext context, int index) {
                return buildNewsArticle(_newsArticles[index]);
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
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(
            article.headline,
            style: UIText.small,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'By ${article.author} on ${article.updatedAt}',
          style: UIText.xsmall,
          overflow: TextOverflow.ellipsis,
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
            child: const Text('Line'),
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
            child: const Text('Area'),
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
            child: const Text('Candle'),
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
            child: const Text('Hollow Candle'),
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
}
