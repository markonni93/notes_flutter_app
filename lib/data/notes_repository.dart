import 'package:flutter_notes/data/notes_data_provider.dart';
import 'package:flutter_notes/ui/model/note_ui_model.dart';

class NotesRepository {
  NotesRepository({NotesDataProvider? notesDataProvider})
      : _notesDataProvider = notesDataProvider ?? NotesDataProvider();

  final NotesDataProvider _notesDataProvider;

  Future<List<NoteUiModel>> getNotes() async {
    final notes = await _notesDataProvider.getNotes();

    return notes.map((model) => NoteUiModel.fromNoteModel(model)).toList();
  }
}
