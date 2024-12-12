import 'dart:async';

import 'package:path/path.dart';
import 'package:quick_notes/data/model/note_model.dart';
import 'package:quick_notes/data/notes_data_provider.dart';
import 'package:sqflite/sqflite.dart';

class NotesDataProviderImpl extends NotesDataProvider {
  static const _dbVersion = 1;
  static const _dbName = "notes.db";
  static const _notesDbTableName = "notes";
  static const _idColumn = "id";
  static const _noteColumn = "note";
  static const _titleColumn = "title";
  static const _createdAtColumn = "createdAt";

  final StreamController<List<NoteModel>> _noteStreamController =
      StreamController.broadcast();

  @override
  Stream<List<NoteModel>> get notesStream => _noteStreamController.stream;

  @override
  Future<void> insertNote(NoteModel model) async {
    try {
      final db = await _database();
      await db.insert(_notesDbTableName, model.toMap());
      _fetchNotes(0);
    } catch (e, stackTrace) {
      print('Error inserting note: $e');
      print(stackTrace);
    }
  }

  @override
  void closeStream() {
    if (!_noteStreamController.isClosed) {
      _noteStreamController.close();
    }
  }

  @override
  void getNotes(int offset) {
    _fetchNotes(offset);
  }

  static Future<Database> _database() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE $_notesDbTableName($_idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $_noteColumn TEXT, $_titleColumn TEXT, $_createdAtColumn TEXT)',
      );
    }, version: _dbVersion);
  }

  Future<void> _fetchNotes(int offset, {int limit = 20}) async {
    try {
      final db = await _database();

      final notes = await db.query(_notesDbTableName,
          limit: limit, offset: offset, orderBy: "$_createdAtColumn DESC");

      final noteModels = notes.map((note) {
        return NoteModel(
          id: note[_idColumn] as int? ?? 0,
          note: note[_noteColumn] as String? ?? '',
          title: note[_titleColumn] as String? ?? '',
          createdAt: note[_createdAtColumn] as String? ?? '',
        );
      }).toList();

      _safeAddToStream(noteModels);
    } catch (e) {
      _noteStreamController.addError(Exception("Error fetching notes $e"));
    }
  }

  void _safeAddToStream(List<NoteModel> noteModels) {
    if (!_noteStreamController.isClosed) {
      _noteStreamController.add(noteModels);
    }
  }
}
