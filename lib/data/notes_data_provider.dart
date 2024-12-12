import 'model/note_model.dart';

abstract class NotesDataProvider {
  Stream<List<NoteModel>> get notesStream;

  Future<void> insertNote(NoteModel model);

  void closeStream();

  void getNotes(int offset);
}
