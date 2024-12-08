import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:quick_notes/routing/notes_app_router.dart';

import 'config/dependencies.dart';
import 'firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.level = Level.all;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // final auth = FirebaseAuth.instanceFor(app: Firebase.app());
  // if (kIsWeb) {
  //   await auth.setPersistence(Persistence.NONE);
  // }

  runApp(MultiProvider(providers: providers, child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true),
      themeMode: ThemeMode.system,
      routerConfig: route(context.read()),
    );
  }
}
//
// class NoteApp extends StatelessWidget {
//   const NoteApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiRepositoryProvider(
//         providers: [
//           RepositoryProvider<NotesRepository>(
//             lazy: true,
//             create: (context) => NotesRepository(),
//           ),
//           RepositoryProvider<NotesCacheManager>(
//               create: (context) => NotesCacheManagerImpl()),
//           RepositoryProvider<AuthenticationRepository>(
//             create: (context) => AuthenticationRepository(
//                 cache: RepositoryProvider.of<NotesCacheManager>(context),
//                 firebaseAuth: FirebaseAuth.instance,
//                 googleSignIn: GoogleSignIn(scopes: ['profile', 'email'])),
//           )
//         ],
//         child: BlocProvider(
//             lazy: false,
//             create: (context) => AppBloc(
//                 authenticationRepository:
//                     RepositoryProvider.of<AuthenticationRepository>(context))
//               ..add(const AppUserSubscriptionRequested()),
//             child: const AppView()));
//   }
// }
//
// class AppView extends StatelessWidget {
//   const AppView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "Note App",
//       theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//           useMaterial3: true),
//       home: FlowBuilder<AuthStatus>(
//         state: context.select((AppBloc bloc) => bloc.state.status),
//         onGeneratePages: _onGenerateViewPages,
//       ),
//     );
//   }
// }
//
// List<Page> _onGenerateViewPages(AuthStatus status, List pages) {
//   return [
//     switch (status) {
//       AuthStatus.authenticated => const MaterialPage(child: MainWidget()),
//       AuthStatus.unauthenticated => const MaterialPage(child: AuthWidget()),
//       AuthStatus.notInitialised =>
//         const MaterialPage(child: CircularProgressIndicator())
//     }
//   ];
// }
