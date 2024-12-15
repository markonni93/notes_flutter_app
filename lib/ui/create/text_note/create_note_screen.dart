import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_notes/ui/create/text_note/create_note_screen_viewmodel.dart';

class CreateNoteScreen extends StatelessWidget {
  const CreateNoteScreen({super.key, required this.viewModel});

  final CreateNoteScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.9,
          leading: IconButton(
              onPressed: () {
                viewModel.insertNotes(
                    "My first note", "aoigaoisgnaisgnaosgiasgiags");
                GoRouter.of(context).pop(true);
              },
              icon: const Icon(Icons.arrow_back_ios)),
          title: const Text("Create note")),
    );
  }
}
