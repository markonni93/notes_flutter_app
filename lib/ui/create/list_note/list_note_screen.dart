import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_notes/data/model/notes/note_model.dart';
import 'package:quick_notes/ui/create/list_note/list_note_screen_viewmodel.dart';
import 'package:quick_notes/ui/create/list_note/widgets/list_note.dart';
import 'package:uuid/uuid.dart';

class CreateListNoteScreen extends StatelessWidget {
  const CreateListNoteScreen({super.key, required this.viewModel});

  final ListNoteScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => {
                  viewModel.insertListNote(ListNoteModel(
                      id: const Uuid().v1(),
                      title: "First list note",
                      createdAt: DateTime.now().toIso8601String(),
                      items: {'first note list': true, 'second note': false, 'third note': false, 'forth note': true}))
                  //GoRouter.of(context).pop()
                },
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: const ListNote(),
    );
  }
}
