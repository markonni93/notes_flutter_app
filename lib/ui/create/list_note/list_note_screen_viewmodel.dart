import 'package:quick_notes/data/model/notes/note_model.dart';
import 'package:quick_notes/data/repositories/notes/notes_repository.dart';

import '../../../util/result.dart';

class ListNoteScreenViewModel {
  ListNoteScreenViewModel({required NotesRepository repository})
      : _repository = repository;

  final NotesRepository _repository;

  Future<Result<void>> insertListNote(ListNoteModel model) async {
    try {
      await _repository.insertListNote(model);
      return const Result.ok(null);
    } catch (e) {
      return Result.error(Exception("Error inserting note"));
    }
  }
}
