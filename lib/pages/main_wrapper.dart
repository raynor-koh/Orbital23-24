import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robinbank_app/bloc/nav_drawer/nav_drawer_bloc.dart';
import 'package:robinbank_app/components/nav_drawer.dart';
import 'package:robinbank_app/pages/home_page.dart';
import 'package:robinbank_app/pages/test_page1.dart';
import 'package:robinbank_app/pages/test_page3.dart';
import 'package:robinbank_app/pages/test_page4.dart';
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
    navDrawerItem = getContentForState(bloc.state.selectedDestination);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NavDrawerBloc>(
      create: (BuildContext context) => bloc,
      child: BlocConsumer<NavDrawerBloc, NavDrawerState>(
        listener: (BuildContext context, NavDrawerState state) {
          navDrawerItem = getContentForState(state.selectedDestination);
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
            appBar: buildAppBar(state),
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

  AppBar buildAppBar(NavDrawerState state) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: UIColours.white,
      ),
      title: Text(
        getAppBarTitle(state.selectedDestination),
        style: UIText.large.copyWith(color: UIColours.white),
      ),
      centerTitle: false,
      backgroundColor: UIColours.blue,
    );
  }

  String getAppBarTitle(NavDrawerDestination selectedDestination) {
    switch (selectedDestination) {
      case NavDrawerDestination.homePage:
        return "HomePage";
      case NavDrawerDestination.testPage1:
        return "TestPage1";
      case NavDrawerDestination.testPage3:
        return "TestPage3";
      case NavDrawerDestination.testPage4:
        return "TestPage4";
      default:
        return "AppBarTitle";
    }
  }

  Widget getContentForState(NavDrawerDestination selectedDestination) {
    switch (selectedDestination) {
      case NavDrawerDestination.homePage:
        return const HomePage();
      case NavDrawerDestination.testPage1:
        return const UserDataPage();
      case NavDrawerDestination.testPage3:
        return const TestPage3();
      case NavDrawerDestination.testPage4:
        return const TestPage4();
      default:
        return Container();
    }
  }
}
