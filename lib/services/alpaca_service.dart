import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:robinbank_app/core/stock/charts/chart_data_point.dart';
import 'package:robinbank_app/core/stock/components/news_article.dart';
import 'package:robinbank_app/env.dart';
import 'package:robinbank_app/utils/constants.dart';

class AlpacaService {
  final String _apiKey = Env.apiKey;
  final String _apiSecret = Env.apiSecret;

  Future<List<Map<String, String>>> searchStock(String query) async {
    final url = Uri.parse('${Constants.alpacaTradingAPIBaseURL}/v2/assets/$query');
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

  Future<List<NewsArticle>> getNewsArticles(String symbol) async {
    final url = Uri.parse('https://data.alpaca.markets/v1beta1/news?symbols=$symbol&limit=8');
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
      throw Exception('Failed to get news articles');
    }
  }

  Future<bool> getIsMarketOpen() async {
    final url = Uri.parse('${Constants.alpacaMarketDataAPIBaseURL}/v2/stocks/AAPL/bars?timeframe=1Min&feed=iex&sort=asc');
    final response = await http.get(url, headers: {
      'APCA-API-KEY-ID': _apiKey,
      'APCA-API-SECRET-KEY': _apiSecret,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final bars = data['bars'];
      return bars != null;
    } else {
      throw Exception('Failed to get market is open');
    }
  }

  Future<Map<String, dynamic>> getStockMetrics(String symbol) async {
    final url = Uri.parse('${Constants.alpacaMarketDataAPIBaseURL}/v2/stocks/snapshots?symbols=$symbol&feed=iex');
    final response = await http.get(url, headers: {
      'APCA-API-KEY-ID': _apiKey,
      'APCA-API-SECRET-KEY': _apiSecret,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final dailyHigh = data[symbol]['dailyBar']['h'];
      final dailyLow = data[symbol]['dailyBar']['l'];
      final dailyVolume = data[symbol]['dailyBar']['v'];
      final dailyTrades = data[symbol]['dailyBar']['n'];
      final latestTradePrice = data[symbol]['latestTrade']['p'];
      final previousClosePrice = data[symbol]['prevDailyBar']['c'];
      final priceDifference = latestTradePrice - previousClosePrice;
      final percentageChange = (priceDifference / previousClosePrice) * 100;
      return {
        'dailyHigh': dailyHigh,
        'dailyLow': dailyLow,
        'dailyVolume': dailyVolume,
        'dailyTrades': dailyTrades,
        'latestTradePrice': latestTradePrice,
        'priceDifference': priceDifference,
        'percentageChange': percentageChange,
      };
    } else {
      throw Exception('Failed to get stock metrics');
    }
  }

  Future<List<ChartDataPoint>> getChartDataPoints(String symbol) async {
    // final url = Uri.parse('${Constants.alpacaMarketDataAPIBaseURL}/v2/stocks/$symbol/bars?timeframe=1Min&feed=iex&sort=asc');
    final url = Uri.parse('https://data.alpaca.markets/v2/stocks/AAPL/bars?timeframe=1Min&start=2024-07-18&feed=iex&sort=asc'); // for testing when market is closed
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
      throw Exception('Failed to get chart data points');
    }
  }

  Future<List<Map<String, dynamic>>> getMostActiveStocks() async {
    final url = Uri.parse('${Constants.alpacaMarketDataAPIBaseURL}/v1beta1/screener/stocks/most-actives?top=20');
    final response = await http.get(url, headers: {
      'APCA-API-KEY-ID': _apiKey,
      'APCA-API-SECRET-KEY': _apiSecret,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final mostActiveStocks = data['most_actives'];
      if (mostActiveStocks != null) {
        return List<Map<String, dynamic>>.from(mostActiveStocks.map((stock) => {
          'symbol': stock['symbol'],
          'volume': stock['volume'],
        }));
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to get most active stocks');
    }
  }

  Future<List<Map<String, dynamic>>> getTopGainers() async {
    final url = Uri.parse('${Constants.alpacaMarketDataAPIBaseURL}/v1beta1/screener/stocks/movers?top=20');
    final response = await http.get(url, headers: {
      'APCA-API-KEY-ID': _apiKey,
      'APCA-API-SECRET-KEY': _apiSecret,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final topGainers = data['gainers'];
      if (topGainers != null) {
        return List<Map<String, dynamic>>.from(topGainers.map((stock) => {
          'symbol': stock['symbol'],
          'percentageChange': stock['percent_change'],
        }));
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to get top gainers');
    }
  }

  Future<List<Map<String, dynamic>>> getTopLosers() async {
    final url = Uri.parse('${Constants.alpacaMarketDataAPIBaseURL}/v1beta1/screener/stocks/movers?top=20');
    final response = await http.get(url, headers: {
      'APCA-API-KEY-ID': _apiKey,
      'APCA-API-SECRET-KEY': _apiSecret,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final topGainers = data['losers'];
      if (topGainers != null) {
        return List<Map<String, dynamic>>.from(topGainers.map((stock) => {
          'symbol': stock['symbol'],
          'percentageChange': stock['percent_change'],
        }));
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to get top gainers');
    }
  }
}
