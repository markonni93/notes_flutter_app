import 'package:flutter/cupertino.dart';
import 'package:quick_notes/ui/core/model/note_ui_model.dart';

import '../../../util/result.dart';
import '../../model/notes/note_model.dart';

abstract class NotesRepository extends ChangeNotifier {
  getNotes(int offset);

  Future<Result<void>> insertNote(NoteModel item);

  Future<Result<void>> insertListNote(ListNoteModel item);

  Future<Result<void>> insertDrawingNote(DrawingNoteModel model);

  Stream<List<NoteUiModel>> getStreamNotes();

  void closeStream();
}
