import 'package:quick_notes/ui/core/model/note_ui_model.dart';

import '../../../util/result.dart';
import '../../model/note_model.dart';

abstract class NotesRepository {
  Future<Result<List<NoteUiModel>>> getNotes(int offset);

  Future<Result<void>> insertNote(NoteModel item);
}
