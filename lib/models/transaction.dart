import 'package:robinbank_app/models/account_position.dart';

class Transaction {
  final String name;
  final String symbol;
  final int quantity;
  final double price;
  final DateTime timeStamp;

  Transaction({
    required this.name,
    required this.symbol,
    required this.quantity,
    required this.price,
    required this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'symbol': symbol,
      'quantity': quantity,
      'price': price,
      'timeStamp': timeStamp,
    };
  }

  factory Transaction.fromMapp(Map<String, dynamic> map) {
    return Transaction(
      name: map['name'] ?? '',
      symbol: map['symbol'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: map['price'] ?? 0,
      timeStamp: map['timeStamp'] ?? DateTime.now(),
    );
  }
}
