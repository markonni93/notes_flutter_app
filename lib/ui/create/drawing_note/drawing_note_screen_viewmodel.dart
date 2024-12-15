import 'dart:typed_data';

import 'package:quick_notes/data/model/notes/note_model.dart';
import 'package:uuid/uuid.dart';

import '../../../data/repositories/notes/notes_repository.dart';

class DrawingNoteScreenViewModel {
  const DrawingNoteScreenViewModel({required NotesRepository repository})
      : _repository = repository;

  final NotesRepository _repository;

  void saveDrawing(Uint8List? pngBytes) async {
    try {
      if (pngBytes != null) {
        _repository.insertDrawingNote(DrawingNoteModel(
            id: Uuid().v1(),
            createdAt: DateTime.now().toIso8601String(),
            sketch: pngBytes));
      }
    } catch (exception) {
      print("Error inserting drawing sketch");
    }
  }
}
