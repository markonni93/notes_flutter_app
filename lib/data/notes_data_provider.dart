import 'dart:async';

import 'package:quick_notes/data/model/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesDataProvider {
  static const _db_version = 1;
  static const _db_name = "notes.db";
  static const _notes_db_table_name = "notes";
  static const _id_column = "id";
  static const _note_column = "note";
  static const _title_column = "title";
  static const _created_at_column = "createdAt";

  static Future<Database> _database() async {
    return openDatabase(join(await getDatabasesPath(), _db_name),
        onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE $_notes_db_table_name($_id_column INTEGER PRIMARY KEY AUTOINCREMENT, $_note_column TEXT, $_title_column TEXT, $_created_at_column TEXT)',
      );
    }, version: _db_version);
  }

  Future<List<NoteModel>> getNotes(int offset) async {
    final db = await _database();

    final List<Map<String, Object?>> notes = await db.query(
        _notes_db_table_name,
        limit: 10,
        offset: offset,
        orderBy: "$_created_at_column DESC");

    return [
      for (final {
            _id_column: id as int,
            _note_column: description as String,
            _title_column: title as String,
            _created_at_column: createdAt as String
          } in notes)
        NoteModel(id: id, note: description, title: title, createdAt: createdAt)
    ];
  }

  Future<NoteModel> getLatestNote() async {
    final db = await _database();

    final List<Map<String, Object?>> noteMap = await db.query(
        _notes_db_table_name,
        limit: 1,
        orderBy: "$_created_at_column DESC");

    final map = noteMap.first;

    return NoteModel(
      id: map[_id_column] as int,
      note: map[_note_column] as String,
      title: map[_title_column] as String,
      createdAt: map[_created_at_column] as String,
    );
  }

  Future<void> insertNote(NoteModel item) async {
    final db = await _database();

    try {
      await db.insert(_notes_db_table_name, item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteNote(int id) async {
    // TODO delete notes here
  }
}
