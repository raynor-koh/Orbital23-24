import 'package:flutter/material.dart';
import 'package:robinbank_app/core/trending/mover_card.dart';
import 'package:robinbank_app/services/alpaca_service.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';

class MarketMoversPage extends StatefulWidget {
  const MarketMoversPage({super.key});

  @override
  State<MarketMoversPage> createState() => _MarketMoversPage();
}

class _MarketMoversPage extends State<MarketMoversPage> {
  final AlpacaService alpacaService = AlpacaService();
  
  bool _isLoading = false;
  final List<String> _categories = ['Most Active', 'Top Gainers', 'Top Losers',];
  String _selectedCategory = 'Most Active';
  List<Map<String, dynamic>> _stocks = [];

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
      switch (category) {
        case 'Most Active':
          _stocks = await alpacaService.getMostActiveStocks();
          break;
        case 'Top Gainers':
          _stocks = await alpacaService.getTopGainers();
          break;
        case 'Top Losers':
          _stocks = await alpacaService.getTopLosers();
          break;
      }
    } catch (e) {
      _isLoading = false;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Container(
            color: UIColours.white,
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(4, 10, 4, 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      backgroundColor: _selectedCategory == category ? UIColours.blue : UIColours.background2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      _loadStates(category);
                    },
                    child: Text(
                      category,
                      style: UIText.small,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: _isLoading
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
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 24, 8, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Symbol',
                                style: UIText.small.copyWith(color: UIColours.secondaryText),
                              ),
                              Text(
                                _selectedCategory == 'Most Active' ? 'Volume' : 'Change (%)',
                                style: UIText.small.copyWith(color: UIColours.secondaryText),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          indent: 8,
                          endIndent: 8,
                          color: UIColours.background2,
                        ),

                        ..._stocks.map((stock) => MoverCard(stock: stock, category: _selectedCategory)),
                      ],
                    ),
                  ),
          ),
        ],
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
          Text(
            'Market Movers',
            style: UIText.large.copyWith(
              color: UIColours.white,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}
