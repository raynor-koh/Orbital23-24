part of 'nav_drawer_bloc.dart';

enum NavDrawerDestination {
  homePage,
  userDataPage,
  signOut,
  transactionHistory
}

class NavDrawerState extends Equatable {
  final NavDrawerDestination selectedDestination;

  const NavDrawerState({
    required this.selectedDestination,
  });

  @override
  List<Object> get props => [selectedDestination];
}
