import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../models/phrase.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('phrases.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, filePath);
    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    await db.execute('''
      CREATE TABLE phrases (
        id $idType,
        text $textType,
        type $textType
      )
    ''');
  }

  Future<void> insertPhrases(List<Phrase> phrases) async {
    final db = await instance.database;
    final batch = db.batch();
    for (var p in phrases) {
      batch.insert('phrases', p.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<List<Phrase>> getPhrases() async {
    final db = await instance.database;
    final maps = await db.query('phrases');
    return maps.map((m) => Phrase.fromMap(m)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
} 