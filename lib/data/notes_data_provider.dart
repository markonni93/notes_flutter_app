import 'package:quick_notes/data/model/notes/note_model.dart';

abstract class NotesDataProvider {
  Stream<List<Note>> get notesStream;

  Future<void> insertNote(NoteModel model);

  void closeStream();

  void getNotes(int offset);

  Future<void> insertListNote(ListNoteModel model);

  Future<void> insertDrawingNote(DrawingNoteModel model);
}
