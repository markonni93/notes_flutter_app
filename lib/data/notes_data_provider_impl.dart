import 'dart:async';

import 'package:path/path.dart';
import 'package:quick_notes/data/model/notes/note_model.dart';
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
  static const _listNotesDbTableName = "listNotes";
  static const _listNoteItemsColumn = "items";

  static Database? _databaseInstance;

  static Future<Database> get _database async {
    if (_databaseInstance != null) return _databaseInstance!;
    _databaseInstance = await _initDatabase();
    return _databaseInstance!;
  }

  static Future<Database> _initDatabase() async {
    try {
      return await openDatabase(
        join(await getDatabasesPath(), _dbName),
        version: _dbVersion,
        onCreate: (db, version) async {
          await db.execute(
            '''
            CREATE TABLE $_notesDbTableName (
              $_idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
              $_noteColumn TEXT,
              $_titleColumn TEXT,
              $_createdAtColumn TEXT
            )
            ''',
          );
          await db.execute(
            '''
            CREATE TABLE $_listNotesDbTableName (
              $_idColumn TEXT,
              $_titleColumn TEXT,
              $_createdAtColumn TEXT,
              $_listNoteItemsColumn TEXT
            )
            ''',
          );
        },
      );
    } catch (e) {
      print("Error initializing database: $e");
      rethrow;
    }
  }

  final StreamController<List<Note>> _noteStreamController =
      StreamController.broadcast();

  @override
  Stream<List<Note>> get notesStream => _noteStreamController.stream;

  @override
  Future<void> insertNote(NoteModel model) async {
    try {
      final db = await _database;
      await db.insert(_notesDbTableName, model.toMap());
      _fetchNotes(0);
    } catch (e, stackTrace) {
      print('Error inserting note: $e');
      print(stackTrace);
    }
  }

  @override
  Future<void> insertListNote(ListNoteModel model) async {
    try {
      final db = await _database;
      await db.insert(_listNotesDbTableName, model.toMap());
      _fetchNotes(0);
    } catch (e) {
      print("Error inserting list note $e");
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

  Future<void> _fetchNotes(int offset, {int limit = 20}) async {
    try {
      final db = await _database;

      final notes = await db.query(_notesDbTableName,
          limit: limit, offset: offset, orderBy: "$_createdAtColumn DESC");

      final listNotes = await db.query(_listNotesDbTableName,
          limit: limit, offset: offset, orderBy: "$_createdAtColumn DESC");

      final noteModels = notes.map((note) {
        return NoteModel(
          id: note[_idColumn] as int? ?? 0,
          note: note[_noteColumn] as String? ?? '',
          title: note[_titleColumn] as String? ?? '',
          createdAt: note[_createdAtColumn] as String? ?? '',
        );
      }).toList();

      final listNoteModels = listNotes.map((note) {
        return ListNoteModel.fromMap(note);
      }).toList();

      final sortedItems = [...noteModels, ...listNoteModels];
      sortedItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      _safeAddToStream(sortedItems);
    } catch (e) {
      _noteStreamController.addError(Exception("Error fetching notes $e"));
    }
  }

  void _safeAddToStream(List<Note> noteModels) {
    if (!_noteStreamController.isClosed) {
      _noteStreamController.add(noteModels);
    }
  }
}
