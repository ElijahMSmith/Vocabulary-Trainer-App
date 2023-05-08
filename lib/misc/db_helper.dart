import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vocab_trainer_app/models/term.dart';

class DBHelper {
  static late String _path;

  static Future<void> loadPathToDB() async {
    String initPath = await getDatabasesPath();
    _path = join(initPath, 'terms.db');
  }

  Future<Database> openDB() async {
    return await openDatabase(_path, version: 1, onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE Term(id INTEGER PRIMARY KEY, termItem TEXT, termLanguage TEXT, definitionItem TEXT, definitionItem TEXT, created TEXT, lastChecked TEXT, scheduleIndex INTEGER, successfulAttempts INTEGER, failedAttempts INTEGER)');
    });
  }

  Future<bool> insertNewTerms(List<Term> newTerms) async {
    for(Term term in newTerms){
      
    }
    return true;
  }
}
