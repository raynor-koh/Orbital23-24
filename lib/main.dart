import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:robinbank_app/pages/home_page_widget.dart';
import 'package:robinbank_app/pages/sign_in_page_widget.dart';
import 'package:robinbank_app/pages/sign_up_page_widget.dart';

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/home',
      name: 'HomePage',
      builder: (context, state) => HomePageWidget(),
    ),
    GoRoute(
      path: '/',
      name: 'SignInPage',
      builder: (context, state) => SignInPageWidget(),
    ),
    GoRoute(
      path: '/signup',
      name: 'SignUpPage',
      builder: (context, state) => SignUpPageWidget(),
    ),
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: _router.routerDelegate,
      routeInformationParser: _router.routeInformationParser,
      routeInformationProvider: _router.routeInformationProvider,
    );
  }
}
