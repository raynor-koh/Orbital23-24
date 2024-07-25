class Transaction {
  final String name;
  final String symbol;
  final int quantity;
  final double price;
  final DateTime timeStamp;
  final bool isBuy;

  Transaction({
    required this.name,
    required this.symbol,
    required this.quantity,
    required this.price,
    required this.timeStamp,
    required this.isBuy,
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

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      name: map['name'] ?? '',
      symbol: map['symbol'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: map['price'].toDouble() ?? 0.0,
      timeStamp: DateTime.parse(map['timeStamp']).toLocal(),
      isBuy: map['isBuy'] ?? false,
    );
  }
}

