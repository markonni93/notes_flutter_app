import 'dart:async';

import 'package:flutter_notes/data/model/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesDataProvider {
  static const _db_version = 1;
  static const _db_name = "notes.db";
  static const _notes_db_table_name = "notes";

  static Future<Database> _database() async {
    return openDatabase(join(await getDatabasesPath(), _db_name),
        onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE $_notes_db_table_name(id INTEGER PRIMARY KEY, note TEXT, title TEXT)',
      );
    }, version: _db_version);
  }

  Future<List<NoteModel>> getNotes() async {
    final db = await _database();

    final List<Map<String, Object?>> notes =
        await db.query(_notes_db_table_name);

    return [
      for (final {
            'id': id as int,
            'note': description as String,
            'title': title as String
          } in notes)
        NoteModel(id: id, note: description, title: title)
    ];
  }

  Future<void> insertNotes(List<NoteModel> items) async {
    final db = await _database();

    try {
      await db.transaction((transaction) async {
        for (var note in items) {
          await transaction.insert(_notes_db_table_name, note.toMap());
        }
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteNote(int id) async {
    // TODO delete notes here
  }
}
