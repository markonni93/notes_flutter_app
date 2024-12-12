import 'dart:async';

import 'package:quick_notes/ui/core/model/note_ui_model.dart';

import '../../../data/repositories/notes/notes_repository.dart';

class HomeScreenViewModel {
  HomeScreenViewModel({required NotesRepository repository})
      : _repository = repository {
    _repository.getStreamNotes().listen((value) {
      _items.addAll(value);
      _offset = _items.length;
      _noteStreamController.add(_items);
      if (value.isEmpty) _allItemsFetched = true;
    });
  }

  final NotesRepository _repository;
  final List<NoteUiModel> _items = [];

  final StreamController<List<NoteUiModel>> _noteStreamController =
      StreamController.broadcast();

  Stream<List<NoteUiModel>> get notesStream => _noteStreamController.stream;

  var _offset = 0;

  var _allItemsFetched = false;

  void fetchNotes() async {
    if (!_allItemsFetched) {
      _repository.getNotes(_offset);
    }
  }

  void disposeNoteStream() {
    _repository.closeStream();
    _noteStreamController.close();
  }
}
