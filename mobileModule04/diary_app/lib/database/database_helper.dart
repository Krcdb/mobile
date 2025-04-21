import 'package:diary_app/database/models/entry.dart';
import 'package:diary_app/database/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "diary.db");

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        date TEXT,
        title TEXT,
        feeling TEXT,
        content TEXT,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');
  }

  Future<int> createUser(User user) async {
    final dbClient = await db;
    return await dbClient.insert('users', user.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    final dbClient = await db;
    final res = await dbClient.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return null;
  }

  Future<int> createEntry(Entry entry) async {
    final dbClient = await db;
    return await dbClient.insert('entries', entry.toMap());
  }

  Future<List<Entry>> getEntriesByUser(int userId) async {
    final dbClient = await db;
    final res = await dbClient.query(
      'entries',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
    return res.map((e) => Entry.fromMap(e)).toList();
  }

  Future<int> deleteEntry(int id) async {
    final dbClient = await db;
    return await dbClient.delete('entries', where: 'id = ?', whereArgs: [id]);
  }
}
