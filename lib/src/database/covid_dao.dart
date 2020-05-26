import 'package:sembast/sembast.dart';
import 'package:template_flutter/src/models/covid19/country.dart';

import 'app_database.dart';

class Covid19Dao {

  static const String FRUIT_STORE_NAME = 'covid19';
  //A store with int keys and Map<String, dynamic> values
  //This store acts like a persistent map, values of Which a fruit object converted to Map
  final _fruitStore = intMapStoreFactory.store(FRUIT_STORE_NAME);

  //Private getter to shorten the amount of code needed to get the
  //singleton instance of an opened database
  Future<Database> get _db async{
    return await AppDatabase.instance.database;
  }

  //insert
  Future insert(CountryObj countryObj ) async{
    await _fruitStore.add(await _db, countryObj.toMap());
  }

  Future delete(CountryObj countryObj) async {
    final finder = Finder(filter: Filter.byKey(countryObj.id));
    await _fruitStore.delete(await _db, finder: finder);
  }

  Future<List<CountryObj>> getAllSortedByName() async{
    //Finder object can also sort data
    final finder = Finder(sortOrders: [
      SortOrder('countryName')
    ]);
    final recordSnapshots = await _fruitStore.find(await _db, finder:  finder);

    //making a list<Fruit> out of list<recordSnapshot>
    return recordSnapshots.map((snapshot) {
      final countryObj = CountryObj.fromJson(snapshot.value);
      //an ID is a key of a record from the database.
      countryObj.id = snapshot.key;
      return countryObj;
    }).toList();
  }
}