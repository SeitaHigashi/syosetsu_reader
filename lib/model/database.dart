import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DatabaseConnection extends AsyncNotifier<List<Map>> {
  late String path;
  late Database database;

  @override
  Future<List<Map>> build() async {
    var databasesPath = await getDatabasesPath();
    path = '$databasesPath/bookshelf.db';
    database = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE Book (id INTEGER PRIMARY KEY AUTOINCREMENT, ncode TEXT, title TEXT, author TEXT, is_download INTEGER, create_date TEXT, update_date TEXT)');
          await db.execute('CREATE TABLE story (id INTEGER PRIMARY KEY AUTOINCREMENT, book_id INTEGER, content TEXT, is_download INTEGER, create_date TEXT, update_date TEXT)');
          await db.execute('CREATE TABLE Bookmark (id INTEGER PRIMARY KEY AUTOINCREMENT, book_id INTEGER, story_num INTEGER, line_num INTEGER, create_date TEXT, update_date TEXT)');
        });
    return [];
  }
}

final dataBaseConnectionProvider = AsyncNotifierProvider<DatabaseConnection, List<Map>>(() {
  return DatabaseConnection();
});