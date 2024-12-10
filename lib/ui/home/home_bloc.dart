import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_notes/ui/core/model/note_ui_model.dart';
import 'package:quick_notes/data/repositories/notes/notes_repository_impl.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this.repository}) : super(const HomeState()) {
    on<NotesFetched>(_onNotesFetched);
    on<NewNoteInserted>(_onNewNoteInserted);
  }

  Future<void> _onNotesFetched(HomeEvent event, Emitter<HomeState> emit) async {
    if (state.hasReachedMax) return;

    // try {
    //   if (state.status == HomeStatus.initial) {
    //     final notes = await repository.getNotes(0);
    //     return emit(state.copyWith(
    //         status: HomeStatus.success, notes: notes, hasReachedMax: false));
    //   }
    //
    //   final notes = await repository.getNotes(state.notes.length);
    //
    //   emit(notes.isEmpty
    //       ? state.copyWith(hasReachedMax: true)
    //       : state.copyWith(
    //           status: HomeStatus.success,
    //           notes: List.of(state.notes)..addAll(notes),
    //           hasReachedMax: false));
    // } catch (e) {
    //   emit(state.copyWith(status: HomeStatus.failure));
    // }
  }

  Future<void> _onNewNoteInserted(
      NewNoteInserted event, Emitter<HomeState> emit) async {
    try {
     // final note = await repository.getLatestNote();

      // return emit(state.copyWith(
      //     status: HomeStatus.success,
      //     notes: List.of([note])..addAll(state.notes),
      //     hasReachedMax: false));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  final NotesRepositoryImpl repository;
}

sealed class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class NotesFetched extends HomeEvent {}

final class NewNoteInserted extends HomeEvent {}

enum HomeStatus { initial, success, failure }

final class HomeState extends Equatable {
  const HomeState(
      {this.status = HomeStatus.initial,
      this.notes = const <NoteUiModel>[],
      this.hasReachedMax = false});

  final HomeStatus status;
  final List<NoteUiModel> notes;
  final bool hasReachedMax;

  HomeState copyWith(
      {HomeStatus? status, List<NoteUiModel>? notes, bool? hasReachedMax}) {
    return HomeState(
        status: status ?? this.status,
        notes: notes ?? this.notes,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  List<Object> get props => [status, notes, hasReachedMax];
}
