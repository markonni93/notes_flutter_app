import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/data/model/note_model.dart';
import 'package:flutter_notes/data/notes_repository.dart';
import 'package:flutter_notes/data/model/ui/note_ui_model.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NotesRepository _repository;

  NoteBloc(this._repository) : super(NoteLoadingState()) {
    on<InsertNoteEvent>((state, emit) async {
      try {
        List<NoteModel> list = [];

        for (var i = 0; i < 100; i++) {
          list.add(NoteModel(
              id: i, note: "Description for my $i note", title: "My $i note"));
        }

        await _repository.insertNotes(list);
        emit(NoteSuccessState(data: []));
      } catch (e) {
        print("Error happened $e");
        emit(NoteErrorState(error: e.toString()));
      }
    });
    on<GetNoteEvent>((state, emit) async {
      try {
        final data = await _repository.getNotes();
        // TODO This is just for practise to see if elements are being rewritten properly
        await Future.delayed(const Duration(seconds: 3));
        emit(NoteSuccessState(data: data));
      } catch (e) {
        emit(NoteErrorState(error: e.toString()));
      }
    });
    on<DeleteNoteEvent>((state, emit) {
      print("Delete note clicked");
    });
  }
}

sealed class NoteState {}

class NoteLoadingState extends NoteState {}

class NoteErrorState extends NoteState {
  final String error;

  NoteErrorState({required this.error});
}

class NoteSuccessState extends NoteState {
  final List<NoteUiModel> data;

  NoteSuccessState({required this.data});
}

sealed class NoteEvent {}

class InsertNoteEvent extends NoteEvent {}

class DeleteNoteEvent extends NoteEvent {}

class GetNoteEvent extends NoteEvent {}
