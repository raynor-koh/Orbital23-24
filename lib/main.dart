import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robinbank_app/pages/main_wrapper.dart';
import 'package:robinbank_app/pages/search_page.dart';
import 'package:robinbank_app/pages/sign_in_page.dart';
import 'package:robinbank_app/pages/sign_up_page.dart';
import 'package:robinbank_app/providers/user_provider.dart';
import 'package:robinbank_app/ui/ui_colours.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInPage(),
      theme: ThemeData(
        scaffoldBackgroundColor: UIColours.lightBackground,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/signinpage': (context) => SignInPage(),
        '/signuppage': (context) => const SignUpPage.SignupPage(),
        '/mainwrapper': (context) => const MainWrapper(),
        '/searchpage': (context) => const SearchPage()
      },
    );
  }
}
