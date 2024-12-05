import 'package:flutter_notes/data/model/note_model.dart';
import 'package:flutter_notes/data/notes_data_provider.dart';
import 'package:flutter_notes/data/model/ui/note_ui_model.dart';

class NotesRepository {
  NotesRepository({NotesDataProvider? notesDataProvider})
      : _notesDataProvider = notesDataProvider ?? NotesDataProvider();

  final NotesDataProvider _notesDataProvider;

  Future<List<NoteUiModel>> getNotes(int offset) async {
    final notes = await _notesDataProvider.getNotes(offset);

    return notes.map((model) => NoteUiModel.fromNoteModel(model)).toList();
  }

  Future<NoteUiModel> getLatestNote() async {
    final note = await _notesDataProvider.getLatestNote();

    return NoteUiModel.fromNoteModel(note);
  }

  Future<void> insertNote(NoteModel item) async {
    try {
      await _notesDataProvider.insertNote(item);
    } catch (e) {
      throw Exception("Failed to insert items in db $e");
    }
  }
}
