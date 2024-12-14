import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_notes/ui/create/list_note/list_note_screen_viewmodel.dart';
import 'package:quick_notes/ui/create/list_note/widgets/list_note.dart';

class CreateListNoteScreen extends StatelessWidget {
  const CreateListNoteScreen({super.key, required this.viewModel});

  final ListNoteScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => GoRouter.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: const ListNote(),
    );
  }
}
