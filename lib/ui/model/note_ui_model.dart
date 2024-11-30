import 'package:flutter_notes/data/model/note_model.dart';

class NoteUiModel {
  final int id;
  final String note;

  NoteUiModel({required this.id, required this.note});

  NoteUiModel.fromNoteModel(NoteModel model)
      : id = model.id,
        note = model.note;
}
