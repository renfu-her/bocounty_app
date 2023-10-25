import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'virtual_items.db';
  static const _databaseVersion = 1;

  static const table = 'items';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnImagePath = 'image_url';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnImagePath TEXT NOT NULL
      )
    ''');

    final items = await getItems();
    if (items.isEmpty) {
      // 資料庫未填充，執行填充預設資料的邏輯
      await _fillDatabaseWithDefaultItems(db);
    }
  }
  Future<void> _fillDatabaseWithDefaultItems(Database db) async {
    final defaultItems = [
      Item(id: 1, name: 'F_boy', imagePath: 'assets/images/face/boy.png'),
      Item(id: 2, name: 'F_girl', imagePath: 'assets/images/face/girl.png'),
      Item(id: 3, name: 'F_healer', imagePath: 'assets/images/face/healer.png'),
      Item(id: 4, name: 'F_killer', imagePath: 'assets/images/face/killer.png'),
      Item(id: 5, name: 'F_knight', imagePath: 'assets/images/face/knight.png'),
      Item(id: 6, name: 'F_wizard', imagePath: 'assets/images/face/wizard.png'),
    ];

    for (final item in defaultItems) {
      await db.insert(table, item.toMap());
    }
  }

  Future<List<Item>> getItems() async {
    final db = await database;
    final maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return Item(
        id: maps[i][columnId] as int,
        name: maps[i][columnName] as String,
        imagePath: maps[i][columnImagePath] as String,
      );
    });
  }

  Future<void> addItem(Item item) async {
    final db = await database;
    await db.insert(table, item.toMap());
  }

  Future<void> updateItem(Item item) async {
    final db = await database;
    await db.update(table, item.toMap(),
        where: '$columnId = ?', whereArgs: [item.id]);
  }

  Future<void> deleteItem(int id) async {
    final db = await database;
    await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  void fetchItemByName(String itemName) async {
    final dbHelper = DatabaseHelper.instance;
    final db = await dbHelper.database;

    final result = await db.query(
      DatabaseHelper.table,
      where: '${DatabaseHelper.columnName} = ?',
      whereArgs: [itemName],
    );

    if (result.isNotEmpty) {
      final item = Item(
        id: result.first[DatabaseHelper.columnId] as int,
        name: result.first[DatabaseHelper.columnName] as String,
        imagePath: result.first[DatabaseHelper.columnImagePath] as String,
      );
      // 使用獲取到的項目進行其他處理
      print(item);
    } else {
      // 找不到符合條件的項目
      print('找不到項目');
    }
  }
}

class Item {
  final int id;
  final String name;
  final String imagePath;

  Item({required this.id, required this.name, required this.imagePath});

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnImagePath: imagePath,
    };
  }
}