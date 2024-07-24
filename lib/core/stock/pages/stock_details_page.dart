import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:robinbank_app/core/stock/components/candle_chart.dart';
import 'package:robinbank_app/core/stock/components/line_chart.dart';
import 'package:robinbank_app/core/stock/components/news_article.dart';
import 'package:robinbank_app/core/stock/components/ohlc_chart.dart';
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

  final List<String> _categories = [
    'Line',
    'Area',
    'Candle',
    'Hollow Candle',
    'OHLC'
  ];
  String _selectedCategory = 'Line';
  final UserPositionService userPositionService = UserPositionService();

  @override
  void initState() {
    super.initState();
    _loadStates(_selectedCategory);
  }

  Future<void> _loadStates(String category) async {
    setState(() {
      _isLoading = true;
      _selectedCategory = category;
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
              onRefresh: () => _loadStates(_selectedCategory),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                  child: Column(
                    children: [
                      StockMetricsPanel(stockMetrics: _stockMetrics),
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
              Container(
                constraints: const BoxConstraints(maxWidth: 250),
                child: Text(
                  widget.name,
                  style: UIText.small.copyWith(color: UIColours.white),
                  overflow: TextOverflow.ellipsis,
                ),
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
          Text(
            article.headline,
            style: UIText.small.copyWith(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'By ${article.author} on ${DateFormat.yMMMd().format(DateTime.parse(article.updatedAt))}',
            style: UIText.xsmall,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => _launchURL(article.url),
            child: Text(
              'Read more',
              style: UIText.xsmall.copyWith(color: UIColours.blue),
            ),
          ),
          const Divider(
            height: 12,
          ),
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
    return Container(
      color: UIColours.white,
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _categories.map((category) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(4, 10, 4, 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                backgroundColor: _selectedCategory == category
                    ? UIColours.blue
                    : UIColours.background2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onPressed: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Text(
                category,
                style: UIText.small.copyWith(
                    color: _selectedCategory == category
                        ? UIColours.white
                        : UIColours.primaryText),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildSelectedChartType() {
    switch (_selectedCategory) {
      case 'Line':
        return LineChart(symbol: widget.symbol, isGradient: true);
      case 'Area':
        return LineChart(symbol: widget.symbol, isGradient: false);
      case 'Candle':
        return CandleChart(symbol: widget.symbol, isHollowCandle: false);
      case 'Hollow Candle':
        return CandleChart(symbol: widget.symbol, isHollowCandle: true);
      case 'OHLC':
        return OHLCChart(symbol: widget.symbol);
      default:
        return Container();
    }
  }
}
