import '../domain/models/user.dart';

enum AuthStatus { authenticated, unauthenticated, notInitialised }

final class AppState {

  const AppState({required AuthStatus status})
      : this._(status: status, user: null);

  const AppState.withUser({NoteUser? user})
      : this._(
            status: user == null
                ? AuthStatus.unauthenticated
                : AuthStatus.authenticated,
            user: user);

  const AppState._({required this.status, this.user});

  final AuthStatus status;
  final NoteUser? user;
}
