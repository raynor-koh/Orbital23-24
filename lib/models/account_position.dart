class AccountPosition {
  final String name;
  final String label;
  final num quantity;
  final num buyPrice;

  AccountPosition({
    required this.name,
    required this.label,
    required this.quantity,
    required this.buyPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'label': label,
      'quantity': quantity,
      'buyPrice': buyPrice,
    };
  }

  factory AccountPosition.fromMap(Map<String, dynamic> map) {
    return AccountPosition(
      name: map['name'] ?? '',
      label: map['label'] ?? '',
      quantity: map['quantity'] ?? 0,
      buyPrice: map['buyPrice'] ?? 0,
    );
  }
}
