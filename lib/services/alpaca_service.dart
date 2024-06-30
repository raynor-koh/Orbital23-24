import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:robinbank_app/components/chart_data_point.dart';
import 'package:robinbank_app/env.dart';
import 'package:robinbank_app/utils/constants.dart';

class AlpacaService {
  final String _apiKey = Env.apiKey;
  final String _apiSecret = Env.apiSecret;

  Future<List<String>> searchStock(String query) async {
    final url = Uri.parse('${Constants.alpacaQueryUri}/$query');
    final response = await http.get(url, headers: {
      'APCA-API-KEY-ID': _apiKey,
      'APCA-API-SECRET-KEY': _apiSecret,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<String> results = [];
      results.add(data['symbol']);
      return results;
    } else {
      throw Exception('Failed to search stock');
    }
  }

  Future<List<ChartDataPoint>> getChartDataPoints(String symbol) async {
    final url = Uri.parse(
        '$_baseUrl/v2/stocks/$symbol/bars?timeframe=1D&start=2024-01-01T00%3A00%3A00Z&end=2024-06-24T23%3A59%3A00Z&limit=1000&adjustment=raw&feed=sip&sort=asc');
    final response = await http.get(url, headers: {
      'APCA-API-KEY-ID': _apiKey,
      'APCA-API-SECRET-KEY': _apiSecret,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final bars = data['bars'];
      return bars.map<ChartDataPoint>((bar) {
        return ChartDataPoint(
          dateTime: DateTime.parse(bar['t']),
          open: bar['o'],
          high: bar['h'],
          low: bar['l'],
          close: bar['c'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load candlestick data');
    }
  }
}
