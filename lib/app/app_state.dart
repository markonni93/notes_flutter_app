import 'package:equatable/equatable.dart';
import 'package:quick_notes/auth/repository/model/user.dart';

enum AuthStatus { authenticated, unauthenticated }

final class AppState extends Equatable {
  const AppState({NoteUser user = NoteUser.empty})
      : this._(
            status: user == NoteUser.empty
                ? AuthStatus.unauthenticated
                : AuthStatus.authenticated,
            user: user);

  const AppState._({required this.status, this.user = NoteUser.empty});

  final AuthStatus status;
  final NoteUser user;

  @override
  List<Object> get props => [status, user];
}
