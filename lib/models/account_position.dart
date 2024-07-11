class AccountPosition {
  final String name;
  final String symbol;
  final num quantity;
  final num price;

  AccountPosition({
    required this.name,
    required this.symbol,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'symbol': symbol,
      'quantity': quantity,
      'price': price,
    };
  }

  factory AccountPosition.fromMap(Map<String, dynamic> map) {
    return AccountPosition(
      name: map['name'] ?? '',
      symbol: map['symbol'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: map['price'] ?? 0,
    );
  }
}
