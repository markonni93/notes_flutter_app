import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_notes/auth/repository/auth_repository.dart';

import '../../data/repositories/auth/auth_exception.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository repository;

  AuthBloc({required this.repository}) : super(const AuthState()) {
    on<SignupUserEvent>(_onStartSignup);
    on<ContinueWithoutSignupEvent>(_onContinueWithoutSignup);
  }

  Future<void> _onStartSignup(
      SignupUserEvent event, Emitter<AuthState> emit) async {
    try {
      await repository.logInWithGoogle();
      emit(state.copyWith(status: SignupStatus.success));
    } on LogInWithGoogleFailure catch (loginFailure) {
      emit(state.copyWith(status: SignupStatus.failure, error: loginFailure.message));
    } catch (e) {
      emit(state.copyWith(status: SignupStatus.failure, error:  "Unknown error ocurred"));
    }
  }

  Future<void> _onContinueWithoutSignup(
      ContinueWithoutSignupEvent event, Emitter<AuthState> emit) async {
    await repository.continueWithoutSignup();
    emit(state.copyWith(status: SignupStatus.skipSignup));
  }
}

sealed class AuthEvent {}

final class SignupUserEvent extends AuthEvent {}

final class ContinueWithoutSignupEvent extends AuthEvent {}

enum SignupStatus { notStarted, success, failure, skipSignup }

final class AuthState {
  const AuthState({this.status = SignupStatus.notStarted, this.error});

  final SignupStatus status;
  final String? error;

  AuthState copyWith({SignupStatus? status, String? error}) {
    return AuthState(status: status ?? this.status, error: error);
  }
}
