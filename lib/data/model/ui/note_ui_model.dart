import 'package:equatable/equatable.dart';
import 'package:flutter_notes/data/model/note_model.dart';

final class NoteUiModel extends Equatable {
  final int id;
  final String note;
  final String title;

  const NoteUiModel({required this.id, required this.note, required this.title});

  NoteUiModel.fromNoteModel(NoteModel model)
      : id = model.id,
        note = model.note,
        title = model.title;

  @override
  List<Object?> get props => [id, note, title];
}
