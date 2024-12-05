import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/data/model/note_model.dart';
import 'package:flutter_notes/data/notes_repository.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NotesRepository repository;

  NoteBloc({required this.repository}) : super(const NoteState()) {
    on<InsertNote>(_insertNote);
  }

  Future<void> _insertNote(InsertNote event, Emitter<NoteState> emit) async {
    try {
      if (event.description.isEmpty && event.title.isEmpty) {
        emit(state.copyWith(status: NoteStatus.discarded));
      } else {
        final model = NoteModel(
            id: 1,
            note: event.description,
            title: event.title,
            createdAt: DateTime.now().toIso8601String());

        await repository.insertNote(model);
        emit(state.copyWith(status: NoteStatus.success));
      }
    } catch (e) {
      print("Error happened $e");
      emit(state.copyWith(status: NoteStatus.failure));
    }
  }
}

final class NoteState {
  const NoteState({this.status = NoteStatus.loading});

  final NoteStatus status;

  NoteState copyWith({NoteStatus? status}) {
    return NoteState(status: status ?? this.status);
  }
}

enum NoteStatus {
  success,
  failure,
  loading,
  discarded;
}

sealed class NoteEvent {}

class InsertNote extends NoteEvent {
  final String title;
  final String description;

  InsertNote({required this.title, required this.description});
}

class RemoveNote extends NoteEvent {
  final int id;

  RemoveNote({required this.id});
}
