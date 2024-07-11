import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:robinbank_app/pages/stock_details_page.dart';
import 'package:robinbank_app/services/alpaca_service.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  List<Map<String, String>> _searchResults = [];
  bool _isLoading = false;

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
        backgroundColor: UIColours.lightBackground,
        title: Row(
          children: [
            Expanded(
              child: CupertinoSearchTextField(
                prefixIcon: Icon(IconlyLight.search),
                placeholder: 'Search',
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
                style: UIText.medium,
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildSearchResults(),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        String symbol = _searchResults[index]['symbol']!;
        String name = _searchResults[index]['name']!;
        return ListTile(
          title: Text('$symbol - $name'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => StockDetailsPage(symbol: symbol)
            ));
          },
        );
      },
    );
  }

  void _performSearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Map<String, String>> results = await AlpacaService().searchStock(query.toUpperCase());
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to search stocks'),
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
