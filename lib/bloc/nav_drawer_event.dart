part of 'nav_drawer_bloc.dart';

class NavDrawerEvent extends Equatable {
  const NavDrawerEvent();

  @override
  List<Object> get props => [];
}

class NavigateTo extends NavDrawerEvent {
  final NavDrawerDestination destination;

  const NavigateTo(
    this.destination,
  );

  @override
  List<Object> get props => [destination];
}
