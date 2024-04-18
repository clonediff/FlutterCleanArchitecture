import 'dart:convert';

import 'package:flutter_clean_architecture/core/error/exception.dart';
import 'package:flutter_clean_architecture/feature/data/models/person_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PersonLocalDataSource {
  /// Get the cached [List<PersonModel>] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present
  Future<List<PersonModel>> getLastPersonsFromCache();

  Future<void> personsToCache(List<PersonModel> persons);
}

const String CACHED_PERSONS_LISTS = 'CACHED_PERSONS_LISTS';

class PersonLocalDataSourceImpl implements PersonLocalDataSource {
  final SharedPreferences sharedPreferences;

  PersonLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<List<PersonModel>> getLastPersonsFromCache() {
    final List<String>? jsonPersonsList =
        sharedPreferences.getStringList(CACHED_PERSONS_LISTS);
    if (jsonPersonsList?.isNotEmpty ?? false) {
      return Future.value(jsonPersonsList!
          .map((person) => PersonModel.fromJson(json.decode(person)))
          .toList());
    }

    throw CacheException();
  }

  @override
  Future<void> personsToCache(List<PersonModel> persons) async {
    final List<String> jsonPersonsList =
        persons.map((person) => json.encode(person.toJson())).toList();

    sharedPreferences.setStringList(CACHED_PERSONS_LISTS, jsonPersonsList);
    print('Persons to write Cache: ${jsonPersonsList.length}');
  }
}
