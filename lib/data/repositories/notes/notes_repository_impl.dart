import 'package:quick_notes/data/model/note_model.dart';
import 'package:quick_notes/data/notes_data_provider.dart';
import 'package:quick_notes/data/repositories/notes/notes_repository.dart';
import 'package:quick_notes/ui/core/model/note_ui_model.dart';

import '../../../util/result.dart';

class NotesRepositoryImpl extends NotesRepository {
  NotesRepositoryImpl({NotesDataProvider? notesDataProvider})
      : _notesDataProvider = notesDataProvider ?? NotesDataProvider();

  final NotesDataProvider _notesDataProvider;

  @override
  Future<Result<List<NoteUiModel>>> getNotes(int offset) async {
    final notes = await _notesDataProvider.getNotes(offset);

    if (notes.isNotEmpty) {
      return Result.ok(
          notes.map((model) => NoteUiModel.fromNoteModel(model)).toList());
    } else {
      return const Result.empty();
    }
  }

  @override
  Future<Result<void>> insertNote(NoteModel item) async {
    try {
      await _notesDataProvider.insertNote(item);
      return const Result.ok(null);
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }
}
