import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction.dart' as my_transaction;

class DBHelper {
  static const String dbName = "transactions.db";
  static const String tableTransactions = "transactions";

  // Open the database
  static Future<Database> _database() async {
    final path = join(await getDatabasesPath(), dbName);
    return openDatabase(
      path,
      version: 2, // Incremented version for future migrations
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableTransactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            amount REAL NOT NULL,
            isIncome INTEGER NOT NULL,
            category TEXT NOT NULL,
            date TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Add migration logic here if necessary (e.g., new columns)
          // Example: 
          // await db.execute('ALTER TABLE $tableTransactions ADD COLUMN new_column TEXT');
        }
      },
    );
  }

  // Insert a new transaction
  static Future<int> insertTransaction(my_transaction.Transaction transaction) async {
    final db = await _database();
    try {
      return await db.insert(
        tableTransactions,
        transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting transaction: $e');
      rethrow;
    }
  }

  // Fetch all transactions
  static Future<List<my_transaction.Transaction>> getTransactions() async {
    final db = await _database();
    try {
      final List<Map<String, dynamic>> maps = await db.query(tableTransactions);
      return List.generate(maps.length, (i) => my_transaction.Transaction.fromMap(maps[i]));
    } catch (e) {
      print('Error fetching transactions: $e');
      return [];
    }
  }

  // Delete a transaction by ID
  static Future<void> deleteTransaction(int id) async {
    final db = await _database();
    try {
      await db.delete(tableTransactions, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting transaction: $e');
    }
  }

  // Update an existing transaction
  static Future<int> updateTransaction(my_transaction.Transaction transaction) async {
    final db = await _database();
    try {
      return await db.update(
        tableTransactions,
        transaction.toMap(),
        where: 'id = ?',
        whereArgs: [transaction.id],
      );
    } catch (e) {
      print('Error updating transaction: $e');
      rethrow;
    }
  }
}
