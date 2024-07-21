import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robinbank_app/models/user.dart';
import 'package:robinbank_app/providers/user_provider.dart';
import 'package:robinbank_app/services/alpaca_service.dart';
import 'package:robinbank_app/services/user_position_service.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';
import 'package:robinbank_app/utils/utils.dart';

class TradePanel extends StatefulWidget {
  final String symbol;
  final String name;

  const TradePanel({
    super.key,
    required this.symbol,
    required this.name,
  });

  @override
  State<TradePanel> createState() => _TradePanelState();
}

class _TradePanelState extends State<TradePanel> {
  final AlpacaService _alpacaService = AlpacaService();
  final UserPositionService _userPositionService = UserPositionService();

  bool _isMarketOpen = true;
  Map<String, dynamic> _stockMetrics = {};
  final List<bool> _selectedSide = [true, false];
  bool _isBuy = true;
  int _quantity = 1;
  
  @override
  void initState() {
    super.initState();
    _loadStates();
  }

  Future<void> _loadStates() async {
    try {
      bool isMarketOpen = await _alpacaService.getIsMarketOpenNow();
      Map<String, dynamic> stockMetrics = await _alpacaService.getStockMetrics(widget.symbol);
      setState(() {
        _isMarketOpen = isMarketOpen;
        _stockMetrics = stockMetrics;
      });
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Side',
                  style: UIText.small,
                ),
                ToggleButtons(
                  isSelected: _selectedSide,
                  borderWidth: 1,
                  borderRadius: BorderRadius.circular(4),
                  selectedColor: Colors.white,
                  selectedBorderColor: _isBuy ? Colors.green[700] : Colors.red[700],
                  fillColor: _isBuy ? Colors.green[200] : Colors.red[200],
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
                      _isBuy = index == 0;
                      for (int i = 0; i < _selectedSide.length; i++) {
                        _selectedSide[i] = i == index;
                      }
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quantity',
                  style: UIText.small,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: _decrementQuantity,
                    ),
                    Text(
                      '$_quantity',
                      style: UIText.small,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _incrementQuantity,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (!_isMarketOpen) {
                      showSnackBar(context, "Market is closed!");
                      return;
                    }
                    Map<String, dynamic> payload = {
                      'symbol': widget.symbol,
                      'name': widget.name,
                      'quantity': _quantity,
                      'price': _stockMetrics['latestTradePrice'],
                    };
                    if (_isBuy) {
                      await _userPositionService.executeBuyTrade(context, user.id, payload);
                    } else {
                      await _userPositionService.executeSellTrade(context, user.id, payload);
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

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }
}