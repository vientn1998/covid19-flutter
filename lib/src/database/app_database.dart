import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class AppDatabase {
  // A private constructor. Allows us to create instances of AppDatabase
  // only from within the AppDatabase class itself.
  AppDatabase._();

  // singleton instance
  static final AppDatabase _singleton = AppDatabase._();

  //singleton accessor
  static AppDatabase get instance => _singleton;

  //completer is used for transforming synchronous code into asynchronous code
  Completer<Database> _dbOpenCompleter;

  //Sembast database object
  Database _database;

  //Database object accessor
  Future<Database> get database async {
    //If completer is null, AppdatabaseClass is newly instantiated, so database is not yet open
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      //calling _openDatabase will also complete the completer with database instance
      _openDatabase();
    }
    return _dbOpenCompleter.future;
  }

  //open database
  Future _openDatabase() async {
    //Get a platform-specific directory where persistent app data can be stored
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    //path with the form: /platform-specific-directory/demo.db
    final dbPath = join(appDocumentDirectory.path, 'covid19.db');

    final database = await databaseFactoryIo.openDatabase(dbPath);
    //any code waiting the completer future will now start executing
    _dbOpenCompleter.complete(database);
  }

}
