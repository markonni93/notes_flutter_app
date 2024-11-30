import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'business/note_bloc.dart';
import 'data/notes_repository.dart';

void main() {
  runApp(NotesApp(repository: NotesRepository()));
}

class NotesApp extends StatelessWidget {
  const NotesApp({Key? key, required NotesRepository repository})
      : _notesRepository = repository,
        super(key: key);

  final NotesRepository _notesRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: _notesRepository,
        child: BlocProvider(
            create: (context) => NoteBloc(context.read<NotesRepository>()),
            child: const HomeScreen()));
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SafeArea(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () => context.read<NoteBloc>().add(InsertNoteEvent()),
              child: const Text("Insert note")),
          ElevatedButton(
              onPressed: () => context.read<NoteBloc>().add(DeleteNoteEvent()),
              child: const Text("Delete note")),
          ElevatedButton(
              onPressed: () => context.read<NoteBloc>().add(GetNoteEvent()),
              child: const Text("Get note"))
        ],
      )),
    );
  }
}
