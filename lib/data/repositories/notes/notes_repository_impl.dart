import 'package:quick_notes/data/repositories/notes/notes_repository.dart';
import 'package:quick_notes/ui/core/model/note_ui_model.dart';

import '../../../util/result.dart';
import '../../model/notes/note_model.dart';
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
  Future<Result<void>> insertListNote(ListNoteModel item) async {
    try {
      await _notesDataProvider.insertListNote(item);
      return const Result.ok(null);
    } catch (exception) {
      return Result.error(exception as Exception);
    }
  }

  @override
  Stream<List<NoteUiModel>> getStreamNotes() async* {
    yield* _notesDataProvider.notesStream
        .map((items) => items
            .map((noteModel) => switch (noteModel) {
                  ListNoteModel() =>
                    ListNoteUiModel.fromListNoteModel(noteModel),
                  NoteModel() => TextNoteUiModel.fromNoteModel(noteModel),
                })
            .toList())
        .handleError((error) {
      throw Exception("Error fetching notes $error");
    });
  }

  @override
  void closeStream() {
    _notesDataProvider.closeStream();
  }
}
