import 'package:flutter/material.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';

class MarketMoversPage extends StatefulWidget {
  const MarketMoversPage({super.key});

  @override
  State<MarketMoversPage> createState() => _MarketMoversPage();
}

class _MarketMoversPage extends State<MarketMoversPage> with TickerProviderStateMixin {
  bool isPageLoading = false;
  late TabController _tabController;
  List<String> tabs = ['Most Active', 'Top Gainers', 'Top Losers'];

  List<Map<String, dynamic>> stockData = [
    {'symbol': 'DNA', 'name': 'Gingko Bioworks Hold...', 'volume': '34.5'},
    {'symbol': 'TELL', 'name': 'Tellurian', 'volume': '29.3'},
    {'symbol': 'LESL', 'name': 'Leslie\'s, Inc.', 'volume': '28.8'},
    {'symbol': 'NCPL', 'name': 'Netcapital Inc', 'volume': '25.7'},
    {'symbol': 'ABEV', 'name': 'Ambev', 'volume': '24.4'},
    {'symbol': 'ET', 'name': 'Energy Transfer L.P', 'volume': '21.9'},
    {'symbol': 'HBAN', 'name': 'Huntington Bancshar...', 'volume': '21.2'},
    {'symbol': 'RUN', 'name': 'Sunrun Inc', 'volume': '21.1'},
    {'symbol': 'SWN', 'name': 'Southwestern Energy...', 'volume': '21.0'},
  ];

  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshPage() async {
    await Future.wait([
      
    ]);
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
          : Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: tabs.map((String name) => Tab(text: name)).toList(),
                  labelColor: UIColours.blue,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: UIColours.blue,
                ),
                Expanded(
                  child: RefreshIndicator(
                    backgroundColor: UIColours.white,
                    color: UIColours.blue,
                    onRefresh: _refreshPage,
                    child: TabBarView(
                      controller: _tabController,
                      children: tabs.map((String name) {
                        return ListView.builder(
                          itemCount: stockData.length,
                          itemBuilder: (context, index) {
                            return StockListItem(stock: stockData[index]);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
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
                'Market Movers',
                style: UIText.large.copyWith(color: UIColours.white)
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StockListItem extends StatelessWidget {
  final Map<String, dynamic> stock;

  const StockListItem({Key? key, required this.stock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(stock['symbol'], style: UIText.medium.copyWith(fontWeight: FontWeight.bold)),
      subtitle: Text(stock['name'], style: UIText.small),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('Volume', style: UIText.small.copyWith(color: Colors.grey)),
          Text('${stock['volume']}', style: UIText.medium.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
      // You can add the spark chart here
    );
  }
}
