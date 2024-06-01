import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'nav_drawer_event.dart';
part 'nav_drawer_state.dart';

class NavDrawerBloc extends Bloc<NavDrawerEvent, NavDrawerState> {
  NavDrawerBloc()
      : super(const NavDrawerState(
            selectedDestination: NavDrawerDestination.homePage)) {
    on<NavigateTo>((event, emit) {
      if (event.destination != state.selectedDestination) {
        emit(NavDrawerState(selectedDestination: event.destination));
      }
    });
  }
}
