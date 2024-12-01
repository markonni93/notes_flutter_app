import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/ui/model/note_ui_model.dart';

import 'business/note_bloc.dart';
import 'common/widgets/note_loading_indicator.dart';
import 'data/notes_repository.dart';

void main() {
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
          )
        ],
        child: MaterialApp(
          title: "Note App",
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true),
          home: const Scaffold(body: HomeScreen()),
        ));
  }
}

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Something")));
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            NoteBloc(RepositoryProvider.of<NotesRepository>(context))
              ..add(GetNoteEvent()),
        child: const SafeArea(child: NotesScreen()));
  }
}

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

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
          onPressed: () => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CreateScreen()))
              }),
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
