import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business/note_bloc.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
            child: Scaffold(
                appBar: AppBar(
                    leading: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios)),
                    title: const Text("Create note"),
                    backgroundColor: Colors.blueAccent),
                body: const Column(children: [Text("Create note")],)
                // BlocConsumer<NoteBloc, NoteState>(
                //   listenWhen: (context, state) {
                //     return state is NoteErrorState || state is NoteSuccessState;
                //   },
                //   listener: (context, state) {
                //     if (state is NoteErrorState) {
                //       const snackBar = SnackBar(
                //         content: Text('Error happened!}'),
                //       );
                //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                //     }
                //     if (state is NoteSuccessState) {
                //       const snackBar = SnackBar(
                //         content: Text('Notes inserted! Bravo'),
                //       );
                //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                //     }
                //   },
                //   buildWhen: (context, state) {
                //     return state is NoteLoadingState ||
                //         state is NoteSuccessState;
                //   },
                //   builder: (context, state) {
                //     if (state is NoteLoadingState) {
                //       return const Center(child: Text("Loading in progress"));
                //     } else if (state is NoteSuccessState) {
                //       return const Text("Successfully fetched data");
                //     } else {
                //       throw Exception("Unhandled state");
                //     }
                //   },
                // )
            ));
  }
}
