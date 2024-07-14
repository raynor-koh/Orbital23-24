import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:robinbank_app/components/chart_data_point.dart';
import 'package:robinbank_app/components/news_article.dart';
import 'package:robinbank_app/env.dart';
import 'package:robinbank_app/utils/constants.dart';

class AlpacaService {
  final String _apiKey = Env.apiKey;
  final String _apiSecret = Env.apiSecret;

  Future<List<Map<String, String>>> searchStock(String query) async {
    final url = Uri.parse('${Constants.alpacaQueryUri}/$query');
    final response = await http.get(url, headers: {
      'APCA-API-KEY-ID': _apiKey,
      'APCA-API-SECRET-KEY': _apiSecret,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Map<String, String>> results = [];
      results.add({
        'symbol': data['symbol'],
        'name': data['name'],
      });
      return results;
    } else {
      throw Exception('Failed to search stock');
    }
  }

  Future<Map<String, dynamic>> getStockMetrics(String symbol) async {
    final url = Uri.parse('${Constants.alpacaBaseUrl}/v2/stocks/snapshots?symbols=$symbol&feed=iex');
    final response = await http.get(url, headers: {
      'APCA-API-KEY-ID': _apiKey,
      'APCA-API-SECRET-KEY': _apiSecret,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final latestTradePrice = data[symbol]['latestTrade']['p'];
      final previousClosePrice = data[symbol]['prevDailyBar']['c'];
      final priceDifference = latestTradePrice - previousClosePrice;
      final percentageChange = (priceDifference / previousClosePrice) * 100;
      return {
        'latestTradePrice': latestTradePrice,
        'high': data[symbol]['dailyBar']['h'],
        'low': data[symbol]['dailyBar']['l'],
        'volume': data[symbol]['dailyBar']['v'],
        'previousClosePrice': previousClosePrice,
        'priceDifference': priceDifference,
        'percentageChange': percentageChange,
      };
    } else {
      throw Exception('Failed to load stock metrics');
    }
  }

  Future<List<NewsArticle>> getNewsArticles(String symbol) async {
    final url = Uri.parse('https://data.alpaca.markets/v1beta1/news?sort=desc&symbols=AAPL&limit=3');
    final response = await http.get(url, headers: {
      'APCA-API-KEY-ID': _apiKey,
      'APCA-API-SECRET-KEY': _apiSecret,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final news = data['news'];
      if (news != null) {
        return List<NewsArticle>.from(news.map((article) => NewsArticle.fromJson(article)));
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load news articles');
    }
  }

  Future<List<ChartDataPoint>> getChartDataPoints(String symbol) async {
    // final url = Uri.parse('${Constants.alpacaBaseUrl}/v2/stocks/$symbol/bars?timeframe=1Min&adjustment=raw&feed=iex&sort=asc');
    final url = Uri.parse('https://data.alpaca.markets/v2/stocks/AAPL/bars?timeframe=1Min&start=2024-07-12&limit=10000&adjustment=raw&feed=iex&sort=asc'); // for testing when market is closed
    final response = await http.get(url, headers: {
      'APCA-API-KEY-ID': _apiKey,
      'APCA-API-SECRET-KEY': _apiSecret,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final bars = data['bars'];
      if (bars != null) {
        return bars.map<ChartDataPoint>((bar) {
          return ChartDataPoint(
            dateTime: DateTime.parse(bar['t']),
            open: bar['o'],
            high: bar['h'],
            low: bar['l'],
            close: bar['c'],
            volume: bar['v'],
          );
        }).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load candlestick data');
    }
  }
}
