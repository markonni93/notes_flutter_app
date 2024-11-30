import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/data/notes_repository.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc(this._repository) : super(NoteLoadingState()) {
    on<InsertNoteEvent>((state, emit) {
      print("Insert note clicked");
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

class NoteErrorState extends NoteState {}

class NoteSuccessState extends NoteState {}

sealed class NoteEvent {}

class InsertNoteEvent extends NoteEvent {}

class DeleteNoteEvent extends NoteEvent {}

class GetNoteEvent extends NoteEvent {}
