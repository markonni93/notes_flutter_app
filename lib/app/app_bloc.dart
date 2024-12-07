import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_notes/app/app_event.dart';
import 'package:quick_notes/app/app_state.dart';
import 'package:quick_notes/auth/repository/auth_repository.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthenticationRepository authenticationRepository})
      : _repository = authenticationRepository,
        super(const AppState(status: AuthStatus.notInitialised)) {
    on<AppUserSubscriptionRequested>(_onUserSignupRequested);
    on<LogoutRequested>(_onLogoutPressed);
  }

  final AuthenticationRepository _repository;

  Future<void> _onUserSignupRequested(
      AppUserSubscriptionRequested event, Emitter<AppState> emit) async {
    final defaultUser = await _repository.currentUser;
    return emit.onEach(_repository.user,
        onData: (user) => emit(AppState.withUser(
            user: defaultUser?.isDefault == true ? defaultUser : user)),
        onError: addError);
  }

  void _onLogoutPressed(LogoutRequested event, Emitter<AppState> emit) {
    // TODO Implement logout
  }
}
