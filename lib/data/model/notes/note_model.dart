import 'dart:convert';
import 'dart:typed_data';

sealed class Note {
  const Note();
}

extension NoteExtension on Note {
  String get createdAt {
    if (this is ListNoteModel) {
      return (this as ListNoteModel).createdAt;
    } else if (this is NoteModel) {
      return (this as NoteModel).createdAt;
    } else if (this is DrawingNoteModel) {
      return (this as DrawingNoteModel).createdAt;
    } else {
      throw UnimplementedError('createdAt is not implemented for this type');
    }
  }
}

final class ListNoteModel extends Note {
  final String id;
  final String title;
  final String createdAt;
  final Map<String, bool> items;

  ListNoteModel(
      {required this.id,
      required this.title,
      required this.createdAt,
      required this.items});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt,
      'items': jsonEncode(items)
    };
  }

  factory ListNoteModel.fromMap(Map<String, dynamic> map) {
    return ListNoteModel(
      id: map['id'] as String,
      title: map['title'] as String,
      createdAt: map['createdAt'] as String,
      items: Map<String, bool>.from(jsonDecode(map['items'] as String)),
    );
  }
}

class NoteModel extends Note {
  final int id;
  final String note;
  final String title;
  final String createdAt;

  NoteModel(
      {required this.id,
      required this.note,
      required this.title,
      required this.createdAt});

  Map<String, Object?> toMap() {
    return {'note': note, 'title': title, 'createdAt': createdAt};
  }
}

class DrawingNoteModel extends Note {
  final String id;
  final String createdAt;
  final Uint8List sketch;

  DrawingNoteModel(
      {required this.id, required this.createdAt, required this.sketch});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'sketch': sketch, // Uint8List can be directly used with SQLite
    };
  }

  factory DrawingNoteModel.fromMap(Map<String, dynamic> map) {
    return DrawingNoteModel(
      id: map['id'] as String,
      createdAt: map['createdAt'] as String,
      sketch: map['sketch'] as Uint8List, // BLOB stored as Uint8List
    );
  }
}
