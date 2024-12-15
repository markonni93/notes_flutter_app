import 'package:quick_notes/data/repositories/notes/notes_repository.dart';
import 'package:uuid/uuid.dart';

import '../../../data/model/notes/note_model.dart';

class CreateNoteScreenViewModel {
  const CreateNoteScreenViewModel({required NotesRepository repository})
      : _repository = repository;

  final NotesRepository _repository;

  void insertNotes(String title, String note) async {
    if (title.isNotEmpty || note.isNotEmpty) {
      await _repository.insertNote(NoteModel(
          id: Uuid().v1(),
          note: note,
          title: title,
          createdAt: DateTime.now().toIso8601String()));
    }
  }
}
