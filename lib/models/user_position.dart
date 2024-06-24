import 'dart:convert';

class UserPosition {
  final String userId;
  final num accountBalance;
  final List<AccountPosition> accountPosition;
  final num buyingPower;

  UserPosition({
    required this.userId,
    required this.accountBalance,
    required this.accountPosition,
    required this.buyingPower,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'accountBalance': accountBalance,
      'accountPosition': accountPosition.map((x) => x.toMap()).toList(),
      'buyingPower': buyingPower,
    };
  }

  factory UserPosition.fromMap(Map<String, dynamic> map) {
    return UserPosition(
      userId: map['userId'] ?? '',
      accountBalance: map['accountBalance'] ?? 0,
      accountPosition: (map['accountPosition'] as List)
          .map((x) => AccountPosition.fromMap(x))
          .toList(),
      buyingPower: map['buyingPower'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserPosition.fromJson(String source) =>
      UserPosition.fromMap(json.decode(source));
}

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
