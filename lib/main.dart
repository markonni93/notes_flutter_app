import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:quick_notes/routing/notes_app_router.dart';

import 'config/dependencies.dart';
import 'config/theme/theme.dart';
import 'config/theme/util.dart';
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

  runApp(MultiProvider(
      providers: providers, child: const SafeArea(child: MainApp())));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");
    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: route(context.read()),
    );
  }
}
