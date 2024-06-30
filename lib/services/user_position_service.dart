import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:robinbank_app/providers/user_position_provider.dart';
import 'package:robinbank_app/utils/constants.dart';
import 'package:robinbank_app/utils/utils.dart';

class UserPositionService {
  void getUserPosition(BuildContext context, String userId) async {
    try {
      var userPositonProvider =
          Provider.of<UserPositionProvider>(context, listen: false);

      http.Response response = await http.get(
          Uri.parse('${Constants.uri}/user/$userId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      ;
      userPositonProvider.setUserPosition(response.body);
    } catch (error) {
      log(error.toString());
      showSnackBar(context, error.toString());
    }
  }
}
