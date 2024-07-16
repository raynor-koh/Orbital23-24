import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:robinbank_app/utils/constants.dart';
import 'package:robinbank_app/utils/utils.dart';
import 'package:http/http.dart' as http;

class TransactionService {
  void getUserTransactions(BuildContext context, String userId) async {
    try {
      http.Response response = await http.get(
        Uri.parse('${Constants.serverUri}/transaction/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // TODO: Parse responce json
    } catch (error) {
      log(error.toString());
      showSnackBar(context, error.toString());
    }
  }

  void resetTransactions(BuildContext context, String userId) {
    try {
      // TODO: HTTP GET call to MONGODB
    } catch (error) {
      log(error.toString());
      showSnackBar(context, error.toString());
    }
  }

  void addTransaction(BuildContext context) {
    try {
      // TODO: Add transaction to HTTP
    } catch (error) {
      log(error.toString());
      showSnackBar(context, error.toString());
    }
  }
}
