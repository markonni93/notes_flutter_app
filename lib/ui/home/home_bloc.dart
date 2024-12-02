import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeTabActiveState()) {
    on<TabClickedEvent>((state, emit) {
      final index = state.index;

      switch (index) {
        case 0:
          emit(const HomeTabActiveState());
        case 1:
          emit(const SettingsTabActiveState());
      }
    });
  }
}

sealed class HomeEvent {
  const HomeEvent();
}

class TabClickedEvent extends HomeEvent {
  final int index;

  const TabClickedEvent({required this.index});
}

sealed class HomeState {
  const HomeState();
}

extension HomeStateExtension on HomeState {
  int get currentIndex {
    if (this is HomeTabActiveState) return 0;
    if (this is SettingsTabActiveState) return 1;
    return 0; // Default case
  }
}

final class HomeTabActiveState extends HomeState {
  const HomeTabActiveState();
}

class SettingsTabActiveState extends HomeState {
  const SettingsTabActiveState();
}
