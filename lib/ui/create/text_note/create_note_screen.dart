import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_notes/data/model/note_model.dart';
import 'package:quick_notes/data/repositories/notes/notes_repository.dart';

class CreateNoteScreen extends StatelessWidget {
  const CreateNoteScreen({super.key, required this.repository});

  final NotesRepository repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.9,
          leading: IconButton(
              onPressed: () => {
                    _insertNotes(context)
                    //GoRouter.of(context).pop(true)
                  },
              icon: const Icon(Icons.arrow_back_ios)),
          title: const Text("Create note")),
    );
  }

  void _insertNotes(BuildContext context) async {
    final id = Random.secure().nextInt(10000);
    await repository.insertNote(NoteModel(
        id: id,
        note: "Description note $id",
        title: "Note title $id",
        createdAt: DateTime.now().toIso8601String()));
    GoRouter.of(context).pop();
  }
}
