import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/ui/model/note_ui_model.dart';

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
            create: (context) =>
                NoteBloc(context.read<NotesRepository>())..add(GetNoteEvent()),
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
      body: BlocConsumer<NoteBloc, NoteState>(
        listenWhen: (context, state) {
          return state is NoteErrorState;
        },
        listener: (context, state) {
          if (state is NoteErrorState) {
            const snackBar = SnackBar(
              content: Text('Yay! A SnackBar!'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        buildWhen: (context, state) {
          return state is NoteLoadingState || state is NoteSuccessState;
        },
        builder: (context, state) {
          if (state is NoteLoadingState) {
            return const NoteLoadingIndicator();
          } else if (state is NoteSuccessState) {
            return NoteList(items: state.data);
          } else {
            throw Exception("Unhandled state");
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => context.read<NoteBloc>().add(InsertNoteEvent())),
    );
  }
}

class NoteList extends StatelessWidget {
  final List<NoteUiModel> items;

  const NoteList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Column(
            children: [
              Text("Title is ${item.title}"),
              Text("Description is ${item.note}")
            ],
          );
        });
  }
}
