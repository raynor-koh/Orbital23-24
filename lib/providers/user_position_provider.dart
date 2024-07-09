import 'package:flutter/material.dart';
import 'package:robinbank_app/models/user_position.dart';

class UserPositionProvider extends ChangeNotifier {
  UserPosition _userPosition = UserPosition(
    userId: '',
    accountBalance: 0,
    accountPositions: [],
    buyingPower: 0,
  );

  UserPosition get userPosition => _userPosition;

  void setUserPosition(String userPosition) {
    _userPosition = UserPosition.fromJson(userPosition);
    notifyListeners();
  }

  void setUserPositionFromModel(UserPosition userPosition) {
    _userPosition = userPosition;
    notifyListeners();
  }

  void updateAccountBalance(double newBalance) {
    _userPosition = _userPosition.copyWith(accountBalance: newBalance);
    notifyListeners();
  }
}
