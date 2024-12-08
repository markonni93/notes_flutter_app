import 'dart:async';

import 'package:path/path.dart';
import 'package:quick_notes/data/model/note_model.dart';
import 'package:sqflite/sqflite.dart';

class NotesDataProvider {
  static const _dbVersion = 1;
  static const _dbName = "notes.db";
  static const _notesDbTableName = "notes";
  static const _idColumn = "id";
  static const _noteColumn = "note";
  static const _titleColumn = "title";
  static const _createdAtColumn = "createdAt";

  static Future<Database> _database() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE $_notesDbTableName($_idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $_noteColumn TEXT, $_titleColumn TEXT, $_createdAtColumn TEXT)',
      );
    }, version: _dbVersion);
  }

  Future<List<NoteModel>> getNotes(int offset) async {
    final db = await _database();

    final List<Map<String, Object?>> notes = await db.query(_notesDbTableName,
        limit: 10, offset: offset, orderBy: "$_createdAtColumn DESC");

    return [
      for (final {
            _idColumn: id as int,
            _noteColumn: description as String,
            _titleColumn: title as String,
            _createdAtColumn: createdAt as String
          } in notes)
        NoteModel(id: id, note: description, title: title, createdAt: createdAt)
    ];
  }

  Future<NoteModel> getLatestNote() async {
    final db = await _database();

    final List<Map<String, Object?>> noteMap = await db.query(_notesDbTableName,
        limit: 1, orderBy: "$_createdAtColumn DESC");

    final map = noteMap.first;

    return NoteModel(
      id: map[_idColumn] as int,
      note: map[_noteColumn] as String,
      title: map[_titleColumn] as String,
      createdAt: map[_createdAtColumn] as String,
    );
  }

  Future<void> insertNote(NoteModel item) async {
    final db = await _database();

    try {
      await db.insert(_notesDbTableName, item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteNote(int id) async {
    // TODO delete notes here
  }
}
