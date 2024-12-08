import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_notes/auth/repository/auth_repository.dart';

import '../domain/models/user.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({required this.repository}) : super(const SettingsState()) {
    on<OnInitSettingsScreen>(_fetchCurrentUser);
    on<OnLogoutClicked>(_logoutCurrentUser);
  }

  Future<void> _fetchCurrentUser(
      OnInitSettingsScreen event, Emitter<SettingsState> emit) async {
    final user = await repository.currentUser;

    if (user != null) {
      emit(SettingsState(user: user));
    }
  }

  Future<void> _logoutCurrentUser(
      OnLogoutClicked event, Emitter<SettingsState> emit) async {
    try {
      await repository.logoutCurrentUser();
    } catch (e) {
      print("Something went wrong");
    }
  }

  final AuthenticationRepository repository;
}

sealed class SettingsEvent {}

final class OnInitSettingsScreen extends SettingsEvent {}

final class OnLogoutClicked extends SettingsEvent {}

final class SettingsState {
  const SettingsState({this.user});

  SettingsState copyWith({NoteUser? user}) {
    return SettingsState(user: user);
  }

  final NoteUser? user;
}
