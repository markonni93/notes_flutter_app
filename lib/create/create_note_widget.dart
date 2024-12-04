import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business/note_bloc.dart';
import '../data/notes_repository.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

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
          }
        }, builder: (context, state) {
          return SafeArea(
              child: Scaffold(
                  appBar: AppBar(
                      leading: IconButton(
                          onPressed: () => {
                                context.read<NoteBloc>()
                                  ..add(InsertNote(
                                      title: "My title",
                                      description: "My description"))
                                //Navigator.of(context).pop()
                              },
                          icon: const Icon(Icons.arrow_back_ios)),
                      title: const Text("Create note"),
                      backgroundColor: Colors.blueAccent),
                  body: const Column(
                    children: [Text("Create note")],
                  )));
        }));
  }
}
