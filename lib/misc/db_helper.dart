import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vocab_trainer_app/models/term.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  Database? _db;

  factory DBHelper() {
    return _instance;
  }

  DBHelper._internal();

  Future<void> initialize() async {
    String initPath = await getDatabasesPath();
    _db = await openDatabase(
      join(initPath, 'terms.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE Term(id INTEGER PRIMARY KEY, termItem TEXT, termLanguage TEXT, definitionItem TEXT, definitionLanguage TEXT, created INTEGER, lastChecked INTEGER, scheduleIndex INTEGER, successfulAttempts INTEGER, failedAttempts INTEGER)');
      },
    );
  }

  void insertNewTerms(List<Term> newTerms) async {
    for (Term term in newTerms) {
      await _db!.transaction((txn) async {
        int idInDB = await txn.insert("Term", term.toMap());
        term.id = idInDB;
      });
    }
  }

  Future<List<Term>> getAllTerms() async {
    return (await _db!.rawQuery('SELECT * FROM Term')).map((item) {
      return Term.fromQueryResult(item);
    }).toList();
  }

  Future<bool> updateTerm(Term updatedTerm) async {
    Map<String, Object> values = updatedTerm.toMap();
    int affected = await _db!.rawUpdate(
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
    return affected > 0;
  }

  Future<bool> resetWait(Term term) async {
    int affected = await _db!
        .rawUpdate('UPDATE Term SET scheduleIndex = 0 WHERE id = ${term.id}');
    return affected > 0;
  }

  Future<bool> resetAllWaits() async {
    int affected = await _db!.rawUpdate('UPDATE Term SET scheduleIndex = 0');
    return affected > 0;
  }

  Future<bool> deleteTerm(Term toDelete) async {
    int affected =
        await _db!.rawDelete('DELETE FROM Term WHERE id = ${toDelete.id}');
    return affected > 0;
  }

  Future<bool> deleteAllTerms() async {
    int affected = await _db!.rawDelete('DELETE FROM Term');
    return affected > 0;
  }

  Future<int> getNextId() async {
    List<Map<String, Object?>> items =
        await _db!.rawQuery('SELECT id FROM Term ORDER BY id DESC LIMIT 1');
    return items.isNotEmpty ? (items[0]["id"] as int) + 1 : 0;
  }
}
