import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:robinbank_app/main.dart';
import 'package:robinbank_app/pages/sign_in_page.dart';
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
        token: '',
      );

      http.Response response = await http.post(
        Uri.parse('${Constants.serverUri}/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

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
      final navigator = Navigator.of(context);
      http.Response response =
          await http.post(Uri.parse('${Constants.serverUri}/signin'),
              body: jsonEncode({
                'email': email,
                'password': password,
              }),
              headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          userProvider.setUser(response.body);
          await prefs.setString(
              'x-auth-token', jsonDecode(response.body)['token']);
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MyApp()),
            (route) => false,
          );
          // Navigator.pushNamed(context, '/mainwrapper');
        },
      );
    } catch (error) {
      log(error.toString());
      showSnackBar(context, error.toString());
    }
  }

  // Get User Data
  void getUserData(
    BuildContext context,
  ) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenResponse = await http.post(
        Uri.parse('${Constants.serverUri}/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      var response = jsonDecode(tokenResponse.body);

      if (response == true) {
        http.Response userResponse = await http.get(
            Uri.parse('${Constants.serverUri}/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token,
            });

        userProvider.setUser(userResponse.body);
      }
    } catch (error) {
      log(error.toString());
      showSnackBar(context, error.toString());
    }
  }

  // Sign Out
  void signOutUser(BuildContext context) async {
    final navigator = Navigator.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('x-auth-token', '');
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const SignInPage()),
      (route) => false,
    );
  }
}
