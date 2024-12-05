import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainWidgetBloc extends Bloc<MainWidgetEvent, MainWidgetState> {
  MainWidgetBloc() : super(const MainInitState()) {
    on<TabClickedEvent>((state, emit) {
      final index = state.index;

      switch (index) {
        case 0:
          emit(const HomeTabActiveState());
        case 1:
          emit(const SettingsTabActiveState());
      }
    });

    on<CheckAuth>(_checkIsUserAuth);
  }

  Future<void> _checkIsUserAuth(
      MainWidgetEvent event, Emitter<MainWidgetState> emit) async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        emit(const StartLogin());
      } else {
        print('User is signed in!');
        emit(const StartHome());
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

class CheckAuth extends MainWidgetEvent {}

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

// TODO this is stupid, see if you can avoid it
final class MainInitState extends MainWidgetState {
  const MainInitState();
}

final class HomeTabActiveState extends MainWidgetState {
  const HomeTabActiveState();
}

final class SettingsTabActiveState extends MainWidgetState {
  const SettingsTabActiveState();
}

final class StartLogin extends MainWidgetState {
  const StartLogin();
}

final class StartHome extends MainWidgetState {
  const StartHome();
}
