import 'package:flutter/material.dart';
import 'package:robinbank_app/pages/main_wrapper.dart';
import 'package:robinbank_app/pages/sign_in_page.dart';
import 'package:robinbank_app/pages/sign_up_page.dart';
import 'package:robinbank_app/ui/ui_colours.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInPage(),
      theme: ThemeData(
        scaffoldBackgroundColor: UIColours.surfaceDim,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/signinpage': (context) => SignInPage(),
        '/signuppage': (context) => SignUpPage(),
        '/mainwrapper': (context) => const MainWrapper(),
      },
    );
  }
}
