import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robinbank_app/core/navigation/pages/main_wrapper.dart';
import 'package:robinbank_app/core/search/search_page.dart';
import 'package:robinbank_app/core/authentication/pages/sign_in_page.dart';
import 'package:robinbank_app/core/authentication/pages/sign_up_page.dart';
import 'package:robinbank_app/core/trending/pages/market_movers_page.dart';
import 'package:robinbank_app/providers/user_position_provider.dart';
import 'package:robinbank_app/providers/user_provider.dart';
import 'package:robinbank_app/services/auth_service.dart';
import 'package:robinbank_app/ui/ui_colours.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => UserPositionProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Provider.of<UserProvider>(context).user.token.isEmpty
          ? const SignInPage()
          : const MainWrapper(),
      theme: ThemeData(
        scaffoldBackgroundColor: UIColours.background1,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: UIColours.blue,
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/signinpage': (context) => const SignInPage(),
        '/signuppage': (context) => const SignUpPage(),
        '/mainwrapper': (context) => const MainWrapper(),
        '/searchpage': (context) => const SearchPage(),
        '/marketmoverspage': (context) => const MarketMoversPage(),
      },
    );
  }
}
