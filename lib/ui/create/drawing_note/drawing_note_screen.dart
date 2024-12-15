import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_notes/ui/create/drawing_note/drawing_note_screen_viewmodel.dart';
import 'package:signature/signature.dart';

class DrawingNoteScreen extends StatefulWidget {
  const DrawingNoteScreen(
      {super.key, required DrawingNoteScreenViewModel viewModel})
      : _viewModel = viewModel;

  final DrawingNoteScreenViewModel _viewModel;

  @override
  State<DrawingNoteScreen> createState() => _DrawingNoteScreenState();
}

class _DrawingNoteScreenState extends State<DrawingNoteScreen> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.red,
    exportBackgroundColor: Colors.blue,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () async {
                if (_controller.isNotEmpty) {
                  widget._viewModel.saveDrawing(
                      await _controller.toPngBytes(height: 1080, width: 720));
                }
                GoRouter.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new)),
        ),
        body: Signature(
          controller: _controller,
          backgroundColor: Colors.white70,
        ));
  }
}
