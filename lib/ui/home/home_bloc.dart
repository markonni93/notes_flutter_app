import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/data/notes_repository.dart';
import 'package:flutter_notes/ui/model/note_ui_model.dart';

class HomeBloc extends Bloc<NotesEvent, NoteState> {
  HomeBloc({required this.repository}) : super(const NoteState()) {
    on<NotesFetched>(_onNotesFetched);
  }

  Future<void> _onNotesFetched(
      NotesFetched event, Emitter<NoteState> emit) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == NoteStatus.initial) {
        final notes = await repository.getNotesPaginated(0);
        return emit(state.copyWith(
            status: NoteStatus.success, notes: notes, hasReachedMax: false));
      }

      final notes = await repository.getNotesPaginated(state.notes.length);

      emit(notes.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: NoteStatus.success,
              notes: List.of(state.notes)..addAll(notes),
              hasReachedMax: false));
    } catch (e) {
      emit(state.copyWith(status: NoteStatus.failure));
    }
  }

  final NotesRepository repository;
}

sealed class NotesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class NotesFetched extends NotesEvent {}

enum NoteStatus { initial, success, failure }

final class NoteState extends Equatable {
  const NoteState(
      {this.status = NoteStatus.initial,
      this.notes = const <NoteUiModel>[],
      this.hasReachedMax = false});

  final NoteStatus status;
  final List<NoteUiModel> notes;
  final bool hasReachedMax;

  NoteState copyWith(
      {NoteStatus? status, List<NoteUiModel>? notes, bool? hasReachedMax}) {
    return NoteState(
        status: status ?? this.status,
        notes: notes ?? this.notes,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  List<Object> get props => [status, notes, hasReachedMax];
}
