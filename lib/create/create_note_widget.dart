import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business/note_bloc.dart';
import '../data/notes_repository.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final titleTextController = TextEditingController();
  final noteTextController = TextEditingController();

  @override
  void dispose() {
    titleTextController.dispose();
    noteTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => NoteBloc(
            repository: RepositoryProvider.of<NotesRepository>(context)),
        child: BlocConsumer<NoteBloc, NoteState>(listener: (context, state) {
          switch (state.status) {
            case NoteStatus.success:
              Navigator.of(context).pop();
            case NoteStatus.failure:
              const snackBar = SnackBar(
                content: Text('Error happened!}'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            case NoteStatus.loading:
              break;
            case NoteStatus.discarded:
              const snackBar = SnackBar(
                content: Text('Empty note discarded!}'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.of(context).pop();
          }
        }, builder: (context, state) {
          return SafeArea(
              child: Scaffold(
                  appBar: AppBar(
                      elevation: 0.9,
                      leading: IconButton(
                          onPressed: () => {
                                context.read<NoteBloc>()
                                  ..add(InsertNote(
                                      title: titleTextController.text,
                                      description: noteTextController.text))
                                //Navigator.of(context).pop()
                              },
                          icon: const Icon(Icons.arrow_back_ios)),
                      title: const Text("Create note")),
                  body: Column(
                    children: [
                      TextField(controller: titleTextController),
                      TextField(controller: noteTextController)
                    ],
                  )));
        }));
  }
}
