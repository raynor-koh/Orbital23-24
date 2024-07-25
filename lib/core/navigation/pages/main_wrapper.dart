import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robinbank_app/core/navigation/bloc/nav_drawer_bloc.dart';
import 'package:robinbank_app/core/navigation/components/nav_drawer.dart';
import 'package:robinbank_app/core/home/pages/home_page.dart';
import 'package:robinbank_app/pages/user_data_page.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  late NavDrawerBloc bloc;
  late Widget navDrawerItem;

  @override
  void initState() {
    super.initState();
    bloc = NavDrawerBloc();
    navDrawerItem = _getContentForState(bloc.state.selectedDestination);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NavDrawerBloc>(
      create: (BuildContext context) => bloc,
      child: BlocConsumer<NavDrawerBloc, NavDrawerState>(
        listener: (BuildContext context, NavDrawerState state) {
          navDrawerItem = _getContentForState(state.selectedDestination);
        },
        buildWhen: (previous, current) {
          return previous.selectedDestination != current.selectedDestination;
        },
        listenWhen: (previous, current) {
          return previous.selectedDestination != current.selectedDestination;
        },
        builder: (BuildContext context, NavDrawerState state) {
          return Scaffold(
            drawer: NavDrawer(),
            appBar: _buildAppBar(state),
            body: AnimatedSwitcher(
              switchInCurve: Curves.easeInExpo,
              switchOutCurve: Curves.easeOutExpo,
              duration: const Duration(milliseconds: 200),
              child: navDrawerItem,
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(NavDrawerState state) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: UIColours.white,
      ),
      title: Text(
        _getAppBarTitle(state.selectedDestination),
        style: UIText.large.copyWith(color: UIColours.white),
      ),
      titleSpacing: 4,
      backgroundColor: UIColours.blue,
    );
  }

  String _getAppBarTitle(NavDrawerDestination selectedDestination) {
    switch (selectedDestination) {
      case NavDrawerDestination.homePage:
        return "Home";
      case NavDrawerDestination.profilePage:
        return "Profile";
      default:
        return "HowDidYouGetHere";
    }
  }

  Widget _getContentForState(NavDrawerDestination selectedDestination) {
    switch (selectedDestination) {
      case NavDrawerDestination.homePage:
        return const HomePage();
      case NavDrawerDestination.profilePage:
        return const UserDataPage();
      default:
        return const Scaffold();
    }
  }
}
