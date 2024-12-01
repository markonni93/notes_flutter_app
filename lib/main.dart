import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'business/note_bloc.dart';
import 'common/widgets/note_loading_indicator.dart';
import 'data/notes_repository.dart';

void main() {
  runApp(NotesApp(repository: NotesRepository()));
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key, required NotesRepository repository})
      : _notesRepository = repository;

  final NotesRepository _notesRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: _notesRepository,
        child: BlocProvider(
            create: (context) => NoteBloc(context.read<NotesRepository>()),
            child: MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                  useMaterial3: true,
                ),
                home: const SafeArea(child: HomeScreen()))));
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          BlocBuilder<NoteBloc, NoteState>(builder: (context, state) {
            switch (state) {
              case NoteLoadingState():
                return const NoteLoadingIndicator();
              case NoteErrorState():
                return Text("${state.error}}");
              case NoteSuccessState():
                return const Text("Notes fetched successfully");
            }
          }),
          ElevatedButton(
              onPressed: () => context.read<NoteBloc>().add(InsertNoteEvent()),
              child: const Text("Insert note")),
          ElevatedButton(
              onPressed: () => context.read<NoteBloc>().add(DeleteNoteEvent()),
              child: const Text("Delete note")),
          ElevatedButton(
              onPressed: () => context.read<NoteBloc>().add(GetNoteEvent()),
              child: const Text("Get note")),
        ],
      ),
    ));
  }
}
