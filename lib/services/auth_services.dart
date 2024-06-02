import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
// import 'package:robinbank_app/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:robinbank_app/models/user.dart';
import 'package:robinbank_app/providers/user_provider.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class AuthService {
  void signUpUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        email: email,
        password: password,
        token: '',
      );

      http.Response response = await http.post(
        Uri.parse('${Constants.uri}/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      log('Status Code: ${response.statusCode}');

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () => {
                Navigator.pushNamed(context, '/mainwrapper'),
                showSnackBar(context, 'Account successfully created!')
              });
    } catch (error) {
      log(error.toString());
      showSnackBar(context, error.toString());
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      // final navigator = Navigator.of(context);
      http.Response response =
          await http.post(Uri.parse('${Constants.uri}/signin'),
              body: jsonEncode({
                'email': email,
                'password': password,
              }),
              headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      log('Status Code: ${response.statusCode}');

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          userProvider.setUser(response.body);
          await prefs.setString(
              'x-auth-token', jsonDecode(response.body)['token']);
          // navigator.pushAndRemoveUntil(
          //   MaterialPageRoute(builder: (context) => const HomePage()),
          //   (route) => false,
          // );
          Navigator.pushNamed(context, '/mainwrapper');
        },
      );
    } catch (error) {
      log(error.toString());
      showSnackBar(context, error.toString());
    }
  }
}
