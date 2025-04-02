import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'bus_mitra.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tickets(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        departure TEXT,
        destination TEXT,
        date TEXT,
        time TEXT,
        passengers INTEGER,
        service TEXT,
        qrData TEXT
      )
    ''');
  }

  Future<int> insertTicket(Map<String, dynamic> ticket) async {
    final db = await database;
    return await db.insert('tickets', ticket);
  }

  Future<List<Map<String, dynamic>>> getTickets() async {
    final db = await database;
    return await db.query('tickets');
  }
}