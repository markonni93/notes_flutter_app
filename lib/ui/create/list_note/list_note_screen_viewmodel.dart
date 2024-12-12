import 'package:quick_notes/data/repositories/notes/notes_repository.dart';

class ListNoteScreenViewModel {
  ListNoteScreenViewModel({required NotesRepository repository})
      : _repository = repository;

  final NotesRepository _repository;
}
