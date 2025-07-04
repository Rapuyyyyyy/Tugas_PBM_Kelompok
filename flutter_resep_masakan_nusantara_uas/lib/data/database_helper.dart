import 'dart:io';
import 'package:flutter_resep_masakan_nusantara_uas/data/models/recipe_db_model.dart';
import 'package:flutter_resep_masakan_nusantara_uas/data/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "ResepNusantara.db";
  static const _databaseVersion = 1;

  // Nama Tabel
  static const tableUsers = 'users';
  static const tableFavorites = 'favorites';
  static const tableUserRecipes = 'user_recipes';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableUsers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            phone TEXT NOT NULL,
            password TEXT NOT NULL,
            favoriteFood TEXT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableFavorites (
            recipeId TEXT NOT NULL,
            userId INTEGER NOT NULL,
            isApiRecipe INTEGER NOT NULL, -- 1 jika dari API, 0 jika dari pengguna
            title TEXT NOT NULL,
            imageUrl TEXT NOT NULL,
            PRIMARY KEY (recipeId, userId, isApiRecipe)
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableUserRecipes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            ingredients TEXT NOT NULL,
            instructions TEXT NOT NULL,
            imageUrl TEXT, -- Bisa NULL jika pengguna tidak memasukkan gambar
            userId INTEGER NOT NULL
          )
          ''');
  }

  // User CRUD
  Future<int> registerUser(User user) async {
    Database db = await instance.database;
    return await db.insert(tableUsers, user.toMap());
  }

  Future<User?> login(String email, String password) async {
    Database db = await instance.database;
    var res = await db.query(tableUsers, where: "email = ? AND password = ?", whereArgs: [email, password]);
    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return null;
  }

   Future<int> updateUser(User user) async {
    Database db = await instance.database;
    return await db.update(tableUsers, user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  // Favorite CRUD
  Future<void> addFavorite(Favorite favorite) async {
    final db = await database;
    await db.insert(tableFavorites, favorite.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getFavorites(int userId) async {
    final db = await database;
    return db.query(tableFavorites, where: 'userId = ?', whereArgs: [userId]);
  }

  Future<void> removeFavorite(String recipeId, int userId) async {
    final db = await database;
    await db.delete(tableFavorites, where: 'recipeId = ? AND userId = ?', whereArgs: [recipeId, userId]);
  }

  Future<bool> isFavorite(String recipeId, int userId) async {
    final db = await database;
    final res = await db.query(tableFavorites, where: 'recipeId = ? AND userId = ?', whereArgs: [recipeId, userId]);
    return res.isNotEmpty;
  }

  // User Recipe CRUD
  Future<int> addUserRecipe(UserRecipe recipe) async {
    Database db = await instance.database;
    return await db.insert(tableUserRecipes, recipe.toMap());
  }

  Future<List<UserRecipe>> getUserRecipes(int userId) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableUserRecipes, where: 'userId = ?', whereArgs: [userId]);
    return List.generate(maps.length, (i) => UserRecipe.fromMap(maps[i]));
  }
  
  Future<List<UserRecipe>> getAllUserRecipes() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableUserRecipes);
    return List.generate(maps.length, (i) => UserRecipe.fromMap(maps[i]));
  }


  Future<int> updateUserRecipe(UserRecipe recipe) async {
    Database db = await instance.database;
    return await db.update(tableUserRecipes, recipe.toMap(), where: 'id = ?', whereArgs: [recipe.id]);
  }

  Future<int> deleteUserRecipe(int id) async {
    Database db = await instance.database;
    return await db.delete(tableUserRecipes, where: 'id = ?', whereArgs: [id]);
  }
}