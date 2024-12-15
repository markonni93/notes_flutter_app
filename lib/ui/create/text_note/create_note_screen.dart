import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_notes/ui/create/text_note/create_note_screen_viewmodel.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key, required this.viewModel});

  final CreateNoteScreenViewModel viewModel;

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.9,
          leading: IconButton(
              onPressed: () {
                widget.viewModel
                    .insertNotes(_titleController.text, _noteController.text);
                GoRouter.of(context).pop(true);
              },
              icon: const Icon(Icons.arrow_back_ios)),
          title: const Text("Create note")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextFormField(
              controller: _titleController,
              maxLength: 50,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                counterText: "",
                border: UnderlineInputBorder(),
                labelText: 'Title',
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _noteController,
                minLines: null,
                maxLines: null,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Note',
                ),
              )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
