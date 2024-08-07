import 'dart:convert';
import 'package:robinbank_app/models/account_position.dart';

class UserPosition {
  final String userId;
  final num accountBalance;
  final List<AccountPosition> accountPositions;
  final num buyingPower;

  UserPosition({
    required this.userId,
    required this.accountBalance,
    required this.accountPositions,
    required this.buyingPower,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'accountBalance': accountBalance,
      'accountPosition': accountPositions.map((x) => x.toMap()).toList(),
      'buyingPower': buyingPower,
    };
  }

  factory UserPosition.fromMap(Map<String, dynamic> map) {
    return UserPosition(
      userId: map['userPosition']['userId'] ?? '',
      accountBalance: map['userPosition']['accountBalance'] ?? 0,
      accountPositions: (map['userPosition']['accountPosition'] as List)
          .map((x) => AccountPosition.fromMap(x))
          .toList(),
      buyingPower: map['userPosition']['buyingPower'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserPosition.fromJson(String source) =>
      UserPosition.fromMap(json.decode(source));

  UserPosition copyWith({
    String? userId,
    num? accountBalance,
    List<AccountPosition>? accountPosition,
    num? buyingPower,
  }) {
    return UserPosition(
      userId: userId ?? this.userId,
      accountBalance: accountBalance ?? this.accountBalance,
      accountPositions: accountPosition ?? this.accountPositions,
      buyingPower: buyingPower ?? this.buyingPower,
    );
  }
}
