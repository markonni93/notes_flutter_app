import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/app/app_event.dart';
import 'package:flutter_notes/app/app_state.dart';
import 'package:flutter_notes/auth/repository/auth_repository.dart';
import 'package:flutter_notes/auth/repository/model/user.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthenticationRepository authenticationRepository})
      : _repository = authenticationRepository,
        super(AppState(user: NoteUser.empty)) {
    on<AppUserSubscriptionRequested>(_onUserSignupRequested);
    on<LogoutRequested>(_onLogoutPressed);
  }

  final AuthenticationRepository _repository;

  Future<void> _onUserSignupRequested(
      AppUserSubscriptionRequested event, Emitter<AppState> emit) {
    return emit.onEach(_repository.user,
        onData: (user) => emit(AppState(user: user)), onError: addError);
  }

  void _onLogoutPressed(LogoutRequested event, Emitter<AppState> emit) {
    _repository.logInWithGoogle();
  }
}
