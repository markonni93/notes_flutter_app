import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateNoteScreen extends StatelessWidget {
  const CreateNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.9,
          leading: IconButton(
              onPressed: () => {
                GoRouter.of(context).pop()
                  },
              icon: const Icon(Icons.arrow_back_ios)),
          title: const Text("Create note")),
    );
  }
}
