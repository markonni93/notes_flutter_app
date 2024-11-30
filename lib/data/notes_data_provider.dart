import 'package:flutter_notes/data/model/note_model.dart';

class NotesDataProvider {
  Future<List<NoteModel>> getNotes() async {
    // TODO Implement db here
    return [NoteModel(id: 1, note: "note")];
  }

  Future<void> insertNotes(List<NoteModel> items) async {
    // TODO Insert notes here
  }

  Future<void> deleteNote(int id) async {
    // TODO delete notes here
  }
}
