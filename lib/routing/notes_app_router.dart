import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_notes/data/repositories/auth/auth_repository.dart';
import 'package:quick_notes/ui/create/drawing_note/drawing_note_screen.dart';
import 'package:quick_notes/ui/create/drawing_note/drawing_note_screen_viewmodel.dart';
import 'package:quick_notes/ui/create/list_note/list_note_screen.dart';
import 'package:quick_notes/ui/create/list_note/list_note_screen_viewmodel.dart';
import 'package:quick_notes/ui/create/text_note/create_note_screen.dart';
import 'package:quick_notes/ui/home/widgets/home_screen.dart';

import '../ui/home/view_models/home_screen_viewmodel.dart';
import '../ui/login/view_models/login_viewmodel.dart';
import '../ui/login/widgets/login_screen.dart';
import 'notes_routes.dart';

GoRouter route(AuthRepository authRepository) => GoRouter(
        initialLocation: Routes.home,
        debugLogDiagnostics: true,
  //      redirect: _redirect,
  //      refreshListenable: authRepository,
        routes: [
          // GoRoute(
          //     path: Routes.login,
          //     builder: (context, state) {
          //       return LoginScreen(
          //           viewModel: LoginViewModel(authRepository: context.read()));
          //     }),
          GoRoute(
              path: Routes.home,
              builder: (context, state) {
                return HomeScreen(
                  viewModel: HomeScreenViewModel(repository: context.read()),
                );
              },
              routes: [
                GoRoute(
                    path: Routes.createNote,
                    pageBuilder: (context, state) {
                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: CreateNoteScreen(repository: context.read()),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: CurveTween(curve: Curves.easeInOutCirc)
                                .animate(animation),
                            child: child,
                          );
                        },
                      );
                    }),
                GoRoute(
                    path: Routes.createListNote,
                    pageBuilder: (context, state) {
                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: CreateListNoteScreen(
                            viewModel: ListNoteScreenViewModel(
                                repository: context.read())),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: CurveTween(curve: Curves.easeInOutCirc)
                                .animate(animation),
                            child: child,
                          );
                        },
                      );
                    }),
                GoRoute(
                    path: Routes.createDrawingNote,
                    pageBuilder: (context, state) {
                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: DrawingNoteScreen(
                          viewModel: DrawingNoteScreenViewModel(
                              repository: context.read()),
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: CurveTween(curve: Curves.easeInOutCirc)
                                .animate(animation),
                            child: child,
                          );
                        },
                      );
                    }),
              ]),
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
