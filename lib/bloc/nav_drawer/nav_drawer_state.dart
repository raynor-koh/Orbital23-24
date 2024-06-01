part of 'nav_drawer_bloc.dart';

enum NavDrawerDestination {
  homePage,
  testPage1,
  testPage2,
  testPage3,
  testPage4,
}

class NavDrawerState extends Equatable {
  final NavDrawerDestination selectedDestination;

  const NavDrawerState({
    required this.selectedDestination,
  });

  @override
  List<Object> get props => [selectedDestination];
}
