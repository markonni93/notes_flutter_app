import 'package:equatable/equatable.dart';
import 'package:flutter_notes/data/model/note_model.dart';

final class NoteUiModel extends Equatable {
  final int id;
  final String note;
  final String title;
  final String createdAt;

  const NoteUiModel(
      {required this.id,
      required this.note,
      required this.title,
      required this.createdAt});

  NoteUiModel.fromNoteModel(NoteModel model)
      : id = model.id,
        note = model.note,
        title = model.title,
        createdAt = model.createdAt;

  @override
  List<Object?> get props => [id, note, title, createdAt];
}
