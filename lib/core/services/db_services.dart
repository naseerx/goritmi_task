import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../Models/task_model.dart';

class DBServices {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db!;
    _db = await initDatabase();
    return _db!;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'notes.db');
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        done INTEGER NOT NULL,
        createDate TEXT NOT NULL,
        dueDateTime INTEGER NOT NULL

      )
      ''',
    );
  }

  Future<TaskModel> insert(TaskModel notesModel) async {
    var dbClient = await db;
    await dbClient!.insert('notes', notesModel.toMap());
    return notesModel;
  }

  Future<List<TaskModel>> getAllNotes() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('notes');
    return queryResult.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<int> updateNote(TaskModel notesModel) async {
    var dbClient = await db;
    return await dbClient!.update(
      'notes',
      notesModel.toMap(),
      where: 'id = ?',
      whereArgs: [notesModel.id],
    );
  }

  Future<int> deleteNoteById(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearNotes() async {
    var dbClient = await db;
    await dbClient!.delete('notes');
  }

  Future<void> close() async {
    var dbClient = await db;
    await dbClient!.close();
  }
}
