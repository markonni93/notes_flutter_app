import 'package:quick_notes/data/model/notes/note_model.dart';
import 'package:quick_notes/data/repositories/notes/notes_repository.dart';
import 'package:quick_notes/ui/core/model/note_list_ui_model.dart';
import 'package:uuid/uuid.dart';

import '../../../util/result.dart';

class ListNoteScreenViewModel {
  ListNoteScreenViewModel({required NotesRepository repository})
      : _repository = repository;

  final NotesRepository _repository;

  Future<Result<void>> insertListNote(
      List<NoteListUiModel> items, String title) async {
    try {
      // final Map<String, bool> itemsToInsert =
      //     items.map((element) => Map(element.text, element.isChecked));
      await _repository.insertListNote(ListNoteModel(
          id: const Uuid().v1(),
          title: title,
          createdAt: DateTime.now().toIso8601String(),
          items: {
            'gasgag': true,
            'agags': false,
            'agssag': false,
            'hasdhahah': true
          }));
      return const Result.ok(null);
    } catch (e) {
      return Result.error(Exception("Error inserting note"));
    }
  }
}
