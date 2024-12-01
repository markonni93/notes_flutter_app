import 'package:flutter_notes/data/model/note_model.dart';

class NoteUiModel {
  final int id;
  final String note;
  final String title;

  NoteUiModel({required this.id, required this.note, required this.title});

  NoteUiModel.fromNoteModel(NoteModel model)
      : id = model.id,
        note = model.note,
        title = model.title;
}
