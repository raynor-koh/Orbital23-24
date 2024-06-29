import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:robinbank_app/providers/user_position_provider.dart';
import 'package:robinbank_app/utils/constants.dart';
import '../providers/user_provider.dart';

class TestPage1 extends StatelessWidget {
  const TestPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: sendRequest(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Provider.of<UserProvider>(context).user.toJson(),
                    style: const TextStyle(fontFamily: 'Monospace'),
                  ),
                  Text(
                    Provider.of<UserPositionProvider>(context)
                        .userPosition
                        .toJson(),
                    style: const TextStyle(
                        color: Colors.red, fontFamily: 'Monospace'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<dynamic> sendRequest(BuildContext context) async {
    final userId = Provider.of<UserProvider>(context).user.id;
    final url = '${Constants.uri}/user/$userId';
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
