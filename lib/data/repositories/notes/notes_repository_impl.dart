import 'package:quick_notes/data/model/note_model.dart';
import 'package:quick_notes/data/notes_data_provider_impl.dart';
import 'package:quick_notes/data/repositories/notes/notes_repository.dart';
import 'package:quick_notes/ui/core/model/note_ui_model.dart';

import '../../../util/result.dart';
import '../../notes_data_provider.dart';

class NotesRepositoryImpl extends NotesRepository {
  NotesRepositoryImpl({required NotesDataProvider notesDataProvider})
      : _notesDataProvider = notesDataProvider;

  final NotesDataProvider _notesDataProvider;

  @override
  getNotes(int offset) async {
    _notesDataProvider.getNotes(offset);
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

  @override
  Stream<List<NoteUiModel>> getStreamNotes() async* {
    yield* _notesDataProvider.notesStream
        .map((items) => items
            .map((noteModel) => NoteUiModel.fromNoteModel(noteModel))
            .toList())
        .handleError((error) {
          print("Something went wrong when fetching the notes");
    });
  }

  @override
  void closeStream() {
    _notesDataProvider.closeStream();
  }
}
