import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vocab_trainer_app/models/term.dart';

final List<int> defaultSchedule = [1, 1, 3, 7, 7, 14, 30, 365];

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  Database? _db;

  factory DBHelper() {
    return _instance;
  }

  DBHelper._internal() {
    getDatabasesPath().then((initPath) {
      openDatabase(
        join(initPath, 'terms.db'),
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
              'CREATE TABLE Term(id INTEGER PRIMARY KEY, termItem TEXT, termLanguage TEXT, definitionItem TEXT, definitionLanguage TEXT, created INTEGER, lastChecked INTEGER, scheduleIndex INTEGER, successfulAttempts INTEGER, failedAttempts INTEGER)');
        },
      ).then((db) => _db = db);
    });
  }

  bool get isReady {
    return _db != null;
  }

  Future<bool> insertNewTerms(List<Term> newTerms) async {
    if (!isReady) return false;
    for (Term term in newTerms) {
      await _db!.transaction((txn) async {
        int idInDB = await txn.insert("Term", term.toMap());
        term.id = idInDB;
      });
    }
    return true;
  }

  Future<List<Term>> getAllTerms() async {
    List<Term> res = [];
    if (isReady) {
      List<Map<String, Object?>> items =
          await _db!.rawQuery('SELECT * FROM Term');
      for (Map<String, Object?> item in items)
        res.add(Term.fromQueryResult(item));
    }
    return res;
  }

  Future<bool> updateTerm(Term updatedTerm) async {
    if (!isReady) return false;

    Map<String, Object> values = updatedTerm.toMap();
    await _db!.rawUpdate(
      'UPDATE Term SET termItem = ?, termLanguage = ?, definitionItem = ?, definitionLanguage = ?, created = ?, lastChecked = ?, scheduleIndex = ?, successfulAttempts = ?, failedAttempts = ? WHERE id = ${updatedTerm.id}',
      [
        values["termItem"],
        values["termLanguage"],
        values["definitionItem"],
        values["definitionLanguage"],
        values["created"],
        values["lastChecked"],
        values["scheduleIndex"],
        values["successfulAttempts"],
        values["failedAttempts"]
      ],
    );

    return true;
  }

  Future<bool> resetWait(Term term) async {
    if (!isReady) return false;
    await _db!
        .rawUpdate('UPDATE Term SET scheduleIndex = 0 WHERE id = ${term.id}');
    return true;
  }

  Future<bool> resetAllWaits() async {
    if (!isReady) return false;
    await _db!.rawUpdate('UPDATE Term SET scheduleIndex = 0');
    return true;
  }

  Future<bool> deleteTerm(Term toDelete) async {
    if (!isReady) return false;
    await _db!.rawDelete('DELETE FROM Term WHERE id = ${toDelete.id}');
    return true;
  }

  Future<bool> deleteAllTerms() async {
    if (!isReady) return false;
    await _db!.rawDelete('DELETE FROM Term');
    return true;
  }

  Future<int> getNextId() async {
    if (!isReady) return -1;
    List<Map<String, Object?>> items =
        await _db!.rawQuery('SELECT id FROM test ORDER BY id DESC LIMIT 1');
    return items.isNotEmpty ? items[0]["id"] as int : 0;
  }
}

class DatabaseNotReadyException implements Exception {
  String cause;
  DatabaseNotReadyException(this.cause);
}
