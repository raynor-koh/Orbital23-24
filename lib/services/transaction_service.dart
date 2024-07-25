import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:robinbank_app/core/transaction/components/transaction.dart';
import 'package:robinbank_app/utils/constants.dart';
import 'package:robinbank_app/utils/utils.dart';
import 'package:http/http.dart' as http;

class TransactionService {
  Future<List<Transaction>> getUserTransactions(
      BuildContext context, String userId) async {
    try {
      http.Response response = await http.get(
        Uri.parse('${Constants.serverUri}/transaction/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse response json
        List<Transaction> transactions =
            (jsonDecode(response.body)['transactions'] as List)
                .map((transactionJson) {
          return Transaction.fromMap(transactionJson);
        }).toList();
        return transactions;
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (error) {
      log('From getUserTransactions: ${error.toString()}');
      showSnackBar(context, error.toString());
      return [];
    }
  }

  Future<void> resetTransactions(BuildContext context, String userId) async {
    try {
      http.Response response = await http.get(
        Uri.parse('${Constants.serverUri}/transaction/reset/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        log("Transaction History reset");
      } else {
        showSnackBar(context, jsonDecode(response.body)['message'].toString());
        throw Exception('Failed to reset transaction history');
      }
    } catch (error) {
      log(error.toString());
      showSnackBar(context, error.toString());
    }
  }

  Future<void> addTransaction(
      BuildContext context, String userId, Map<String, dynamic> payload) async {
    try {
      var body = jsonEncode(payload);
      http.Response response = await http.post(
        Uri.parse('${Constants.serverUri}/transaction/add/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      var jsonResponse = jsonDecode(response.body);
      showSnackBar(context, jsonResponse['message']);
      return;
    } catch (error) {
      log(error.toString());
      showSnackBar(context, error.toString());
    }
  }
}
