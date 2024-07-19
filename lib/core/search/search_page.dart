import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:robinbank_app/core/stock/pages/stock_details_page.dart';
import 'package:robinbank_app/services/alpaca_service.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final AlpacaService alpacaService = AlpacaService();

  bool _isLoading = false;
  late TextEditingController _searchController;
  bool _isNoMatchesFound = false;
  List<Map<String, String>> _searchResults = [];
  
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: UIColours.background1,
        title: Row(
          children: [
            Expanded(
              child: CupertinoSearchTextField(
                prefixIcon: const Icon(IconlyLight.search),
                suffixIcon: const Icon(Icons.close),
                placeholder: 'Symbol',
                controller: _searchController,
                onSubmitted: _performSearch,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: UIText.medium.copyWith(),
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
        ? const Center(
            child: RefreshProgressIndicator(
              backgroundColor: UIColours.white,
              color: UIColours.blue,
            ),
          )
        : _isNoMatchesFound
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 80,
                      color: UIColours.red,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sorry, no matches have been found',
                      style: UIText.small,
                    ),
                  ],
                ),
              )
            : _buildSearchResults(),
    );
  }

  void _performSearch(String query) async {
    setState(() {
      _isLoading = true;
      _isNoMatchesFound = false;
    });

    try {
      List<Map<String, String>> results = await alpacaService.searchStock(query.toUpperCase());
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      setState(() {
        _isNoMatchesFound = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        String symbol = _searchResults[index]['symbol']!;
        String name = _searchResults[index]['name']!;
        return ListTile(
          title: Text(
            symbol,
            style: UIText.large.copyWith(color: UIColours.blue),
          ),
          subtitle: Text(
            name,
            style: UIText.small,
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => StockDetailsPage(symbol: symbol, name: name)
            ));
          },
        );
      },
    );
  }
}
