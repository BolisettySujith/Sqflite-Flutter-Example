import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task_manager_app/model/note.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB("notes.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {

    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const boolType = 'BOOLEAN NOT NULL';
    const textType = 'STRING NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE $tableNotes (
        ${NotesFields.id} $idType,
        ${NotesFields.isImportant} $boolType,
        ${NotesFields.number} $integerType,
        ${NotesFields.title} $textType,
        ${NotesFields.description} $textType,
        ${NotesFields.time} $textType
        )
      ''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;

    // For creating our own sql insert query
    // final json = note.toJson();
    // const columns = '${NotesFields.title}, ${NotesFields.description}, ${NotesFields.time}';
    // final values = '${json[NotesFields.title]}, ${json[NotesFields.description]}, ${json[NotesFields.time]}';
    //
    // final id1 = await db
    //     .rawInsert('INSERT INTO $tableNotes ($columns) VALUES ($values)');

    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: NotesFields.values,
      where: '${NotesFields.id} = ?',
      whereArgs: [id]
    );

    if(maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id NOT FOUND');
    }
  }

  Future<List<Note>> readAllNote() async {
    final db = await instance.database;
    const orderBy = '${NotesFields.time} ASC';
    // For writing our own query
    // final result1 = await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableNotes, orderBy: orderBy);

    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note note) async {
     final db = await instance.database;

     return db.update(
       tableNotes,
       note.toJson(),
       where: '${NotesFields.id} == ?',
      whereArgs: [note.id]
     );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${NotesFields.id} == ?',
      whereArgs: [id]
    );
  }
  

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
