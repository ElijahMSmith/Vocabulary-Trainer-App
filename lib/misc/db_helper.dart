import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vocab_trainer_app/models/term.dart';

class DBHelper {
  static late String _path;
  static late Database _db;
  final Logger logger;

  DBHelper() : logger = Logger();

  static Future<void> openDB() async {
    String initPath = await getDatabasesPath();
    _path = join(initPath, 'terms.db');
    _db = await openDatabase(_path, version: 1, onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE Term(id INTEGER PRIMARY KEY, termItem TEXT, termLanguage TEXT, definitionItem TEXT, definitionLanguage TEXT, created INTEGER, lastChecked INTEGER, scheduleIndex INTEGER, successfulAttempts INTEGER, failedAttempts INTEGER)');
    });
  }

  Future<void> insertNewTerms(List<Term> newTerms) async {
    for (Term term in newTerms) {
      await _db.transaction((txn) async {
        int idInDB = await txn.insert("Term", term.toMap());
        term.id = idInDB;
      });
    }
  }

  Future<List<Term>> getAllTerms() async {
    List<Term> res = [];
    List<Map<String, Object?>> items = await _db.rawQuery('SELECT * FROM Term');
    for (Map<String, Object?> item in items) {
      logger.d(item);
      res.add(Term.fromQueryResult(item));
    }
    return res;
  }

  Future<void> clearAll() async {
    await _db.rawDelete('DELETE FROM Term');
  }
}
