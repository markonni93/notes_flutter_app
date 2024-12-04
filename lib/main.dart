import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/data/remote/product_repository.dart';
import 'package:flutter_notes/main_widget.dart';

import 'data/notes_repository.dart';
import 'firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<NotesRepository>(
            create: (context) => NotesRepository(),
          ),
          RepositoryProvider<ProductRepository>(
            create: (context) => ProductRepositoryImpl(),
          )
        ],
        child: MaterialApp(
          title: "Note App",
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true),
          home: const MainWidget(),
        ));
  }
}
