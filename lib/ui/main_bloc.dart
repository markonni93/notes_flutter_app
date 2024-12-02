import 'package:flutter_bloc/flutter_bloc.dart';

class MainWidgetBloc extends Bloc<MainWidgetEvent, MainWidgetState> {
  MainWidgetBloc() : super(const HomeTabActiveState()) {
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

sealed class MainWidgetEvent {
  const MainWidgetEvent();
}

class TabClickedEvent extends MainWidgetEvent {
  final int index;

  const TabClickedEvent({required this.index});
}

sealed class MainWidgetState {
  const MainWidgetState();
}

extension MainWidgetStateExtension on MainWidgetState {
  int get currentIndex {
    if (this is HomeTabActiveState) return 0;
    if (this is SettingsTabActiveState) return 1;
    return 0; // Default case
  }
}

final class HomeTabActiveState extends MainWidgetState {
  const HomeTabActiveState();
}

class SettingsTabActiveState extends MainWidgetState {
  const SettingsTabActiveState();
}
