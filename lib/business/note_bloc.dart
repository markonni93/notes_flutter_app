import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/data/model/note_model.dart';
import 'package:flutter_notes/data/notes_repository.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc(this._repository) : super(NoteLoadingState()) {
    on<InsertNoteEvent>((state, emit) async {
      try {
        await _repository.insertNotes([
          NoteModel(
              id: 1, note: "My first note description", title: "First NOTE"),
          NoteModel(
              id: 2, note: "My second note description", title: "Second NOTE"),
        ]);
        emit(NoteSuccessState());
      } catch (e) {
        emit(NoteErrorState(error: e.toString()));
      }
    });
    on<GetNoteEvent>((state, emit) {
      print("Get note clicked");
    });
    on<DeleteNoteEvent>((state, emit) {
      print("Delete note clicked");
    });
  }

  final NotesRepository _repository;
}

sealed class NoteState {}

class NoteLoadingState extends NoteState {}

class NoteErrorState extends NoteState {
  final String error;

  NoteErrorState({required this.error});
}

class NoteSuccessState extends NoteState {}

sealed class NoteEvent {}

class InsertNoteEvent extends NoteEvent {}

class DeleteNoteEvent extends NoteEvent {}

class GetNoteEvent extends NoteEvent {}
