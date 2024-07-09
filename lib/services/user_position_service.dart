import 'dart:convert';
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
          Uri.parse('${Constants.serverUri}/user/$userId'),
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

  void resetUserPosition(
      BuildContext context, String userId, double resetAmount) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${Constants.serverUri}/user/resetBalance/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        getUserPosition(context, userId);
        var jsonResponse = jsonDecode(response.body);
        String resetMessage = jsonResponse['message'];
        showSnackBar(context, resetMessage);
      } else {
        throw Exception('Failed to reset user position');
      }
    } catch (error) {
      log(error.toString());
      showSnackBar(context, error.toString());
    }
  }
}
