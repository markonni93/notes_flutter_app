import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../../data/model/notes/note_model.dart';

sealed class NoteUiModel extends Equatable {}

final class TextNoteUiModel extends NoteUiModel {
  final String id;
  final String note;
  final String title;
  final String createdAt;

  TextNoteUiModel(
      {required this.id,
      required this.note,
      required this.title,
      required this.createdAt});

  TextNoteUiModel.fromNoteModel(NoteModel model)
      : id = model.id,
        note = model.note,
        title = model.title,
        createdAt = model.createdAt;

  @override
  List<Object?> get props => [id, note, title, createdAt];
}

final class ListNoteUiModel extends NoteUiModel {
  final String id;
  final String title;
  final String createdAt;
  final Map<String, bool> items;

  ListNoteUiModel(
      {required this.id,
      required this.title,
      required this.createdAt,
      required this.items});

  ListNoteUiModel.fromListNoteModel(ListNoteModel model)
      : id = model.id,
        title = model.title,
        createdAt = model.createdAt,
        items = model.items;

  ListNoteUiModel copyWith(
      {String? id,
      String? title,
      String? createdAt,
      Map<String, bool>? items}) {
    return ListNoteUiModel(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [id, title, items];
}

final class DrawingNoteUiModel extends NoteUiModel {
  DrawingNoteUiModel(
      {required this.id, required this.createdAt, required this.sketch});

  final String id;
  final String createdAt;
  final Uint8List sketch;

  DrawingNoteUiModel.fromDrawingNoteModel(DrawingNoteModel model)
      : id = model.id,
        createdAt = model.createdAt,
        sketch = model.sketch;

  @override
  List<Object?> get props => [id, createdAt, sketch];
}
