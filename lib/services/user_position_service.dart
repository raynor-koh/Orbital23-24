import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:robinbank_app/providers/user_position_provider.dart';
import 'package:robinbank_app/utils/constants.dart';
import 'package:robinbank_app/utils/utils.dart';

class UserPositionService {
  Future<void> getUserPosition(BuildContext context, String userId) async {
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
      return;
    } catch (error) {
      log(error.toString());
      showSnackBar(context, error.toString());
    }
  }

  void resetUserPosition(
      BuildContext context, String userId, double resetAmount) async {
    try {
      var payload = json.encode({'amount': resetAmount});
      http.Response response = await http.post(
        Uri.parse('${Constants.serverUri}/user/resetBalance/$userId'),
        body: payload,
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

  Future<int> executeBuyTrade(
      BuildContext context, String userId, Map<String, dynamic> payload) async {
    try {
      var body = json.encode(payload);
      http.Response response = await http.post(
        Uri.parse('${Constants.serverUri}/user/buyStock/$userId'),
        body: body,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        getUserPosition(context, userId);
        var jsonResponse = jsonDecode(response.body);
        String buyMessage = jsonResponse['message'];
        showSnackBar(context, buyMessage);
      } else {
        var jsonResponse = jsonDecode(response.body);
        String buyMessage = jsonResponse['message'];
        showSnackBar(context, buyMessage);
      }
      return 0;
    } catch (error) {
      log(error.toString());
      showSnackBar(context, error.toString());
      return 1;
    }
  }

  Future<void> executeSellTrade(
      BuildContext context, String userId, Map<String, dynamic> payload) async {
    try {
      var body = json.encode(payload);
      http.Response response = await http.post(
        Uri.parse('${Constants.serverUri}/user/sellStock/$userId'),
        body: body,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        getUserPosition(context, userId);
        var jsonResponse = jsonDecode(response.body);
        String sellMessage = jsonResponse['message'];
        showSnackBar(context, sellMessage);
      } else {
        var jsonResponse = jsonDecode(response.body);
        String buyMessage = jsonResponse['message'];
        showSnackBar(context, buyMessage);
      }
      return;
    } catch (error) {
      log(error.toString());
      showSnackBar(context, error.toString());
      return;
    }
  }
}
