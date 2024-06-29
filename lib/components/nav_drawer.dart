import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:robinbank_app/bloc/nav_drawer/nav_drawer_bloc.dart';
import 'package:robinbank_app/models/user.dart';
import 'package:robinbank_app/providers/user_provider.dart';
import 'package:robinbank_app/services/auth_services.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';

class NavDrawerItem {
  final NavDrawerDestination? destination;
  final String title;
  final IconData? icon;

  NavDrawerItem(
    this.destination,
    this.title,
    this.icon,
  );
}

class NavDrawer extends StatelessWidget {
  final List<NavDrawerItem> navDrawerItems = [
    NavDrawerItem(
      NavDrawerDestination.homePage,
      "Home",
      IconlyBold.home,
    ),
    NavDrawerItem(
      NavDrawerDestination.testPage1,
      "TestPage1",
      IconlyBold.profile,
    ),
    NavDrawerItem(
      NavDrawerDestination.testPage2,
      "TestPage2",
      IconlyBold.setting,
    ),
    NavDrawerItem(
      NavDrawerDestination.testPage3,
      "TestPage3",
      IconlyBold.home,
    ),
    NavDrawerItem(
      NavDrawerDestination.testPage4,
      "TestPage4",
      IconlyBold.home,
    ),
    NavDrawerItem(null, "Log Out", null),
  ];

  NavDrawer({super.key});

  void signOutUser(BuildContext context) async {
    log('Successfully signed out.');
    AuthService().signOutUser(context);
  }

  @override
  Widget build(BuildContext context) {
    User userData = Provider.of<UserProvider>(context).user;
    return Drawer(
      backgroundColor: UIColours.white,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              userData.name,
              style: UIText.medium.copyWith(color: UIColours.white),
            ),
            accountEmail: Text(
              userData.email,
              style: UIText.small.copyWith(color: UIColours.white),
            ),
            decoration: const BoxDecoration(
              color: UIColours.blue,
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://i.pinimg.com/736x/0d/64/98/0d64989794b1a4c9d89bff571d3d5842.jpg',
              ),
            ),
          ),
          ListView.builder(
            itemCount: navDrawerItems.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) =>
                BlocBuilder<NavDrawerBloc, NavDrawerState>(
              builder: (BuildContext context, NavDrawerState state) =>
                  buildNavDrawerItem(navDrawerItems[index], state, context),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNavDrawerItem(
      NavDrawerItem data, NavDrawerState state, BuildContext context) {
    if (data.destination == null) {
      return ElevatedButton(
          onPressed: () => signOutUser(context),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.blue),
            textStyle: WidgetStateProperty.all(
              const TextStyle(color: UIColours.secondaryText),
            ),
            minimumSize: WidgetStateProperty.all(
              Size(MediaQuery.of(context).size.width / 2.5, 50),
            ),
          ),
          child: Text(data.title));
    } else {
      return Container(
        color: UIColours.white,
        child: Builder(
          builder: (BuildContext context) {
            return ListTile(
              title: Text(
                data.title,
                style: data.destination == state.selectedDestination
                    ? UIText.medium.copyWith(
                        color: UIColours.blue, fontWeight: FontWeight.bold)
                    : UIText.small,
              ),
              leading: Icon(
                data.icon,
                color: data.destination == state.selectedDestination
                    ? UIColours.blue
                    : UIColours.secondaryText,
              ),
              onTap: () => tapNavDrawerItem(context, data.destination!),
            );
          },
        ),
      );
    }
  }

  void tapNavDrawerItem(
      BuildContext context, NavDrawerDestination destination) {
    BlocProvider.of<NavDrawerBloc>(context).add(NavigateTo(destination));
    Navigator.pop(context);
  }
}
