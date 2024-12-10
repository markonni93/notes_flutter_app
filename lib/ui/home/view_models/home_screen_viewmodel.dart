import 'package:quick_notes/ui/core/model/note_ui_model.dart';
import 'package:quick_notes/util/command.dart';
import 'package:quick_notes/util/result.dart';

import '../../../data/repositories/notes/notes_repository.dart';

class HomeScreenViewModel {
  HomeScreenViewModel({required NotesRepository repository})
      : _repository = repository {
    fetchNotes = Command1(_fetchNotes);
  }

  final NotesRepository _repository;
  late Command1<void, int> fetchNotes;

  List<NoteUiModel> _items = [];
  List<NoteUiModel> get items => _items;

  Future<Result> _fetchNotes(int offset) async {
    print("fetching notes $offset");
    final result = await _repository.getNotes(offset);

    switch (result) {
      case Ok<List<NoteUiModel>>():
        _items = List.of(_items)..addAll(result.value!);
        // todo this is not ok
        return const Result.ok(null);
      case Empty():
        return result;
      case Error():
        return result;
    }
  }
}
