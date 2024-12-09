import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_notes/data/repositories/auth/auth_repository.dart';
import 'package:quick_notes/ui/home/home_screen.dart';

import '../ui/login/view_models/login_viewmodel.dart';
import '../ui/login/widgets/login_screen.dart';
import 'notes_routes.dart';

GoRouter route(AuthRepository authRepository) => GoRouter(
        initialLocation: Routes.home,
        debugLogDiagnostics: true,
        redirect: _redirect,
        refreshListenable: authRepository,
        routes: [
          GoRoute(
              path: Routes.login,
              builder: (context, state) {
                return LoginScreen(
                    viewModel: LoginViewModel(authRepository: context.read()));
              }),
          GoRoute(
              path: Routes.home,
              builder: (context, state) {
                return const HomeScreen();
              })
        ]);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final bool loggedIn = await context.read<AuthRepository>().isAuthenticated;
  final bool loggingIn = state.matchedLocation == Routes.login;
  if (!loggedIn) {
    return Routes.login;
  }

  if (loggingIn) {
    return Routes.home;
  }

  return null;
}
