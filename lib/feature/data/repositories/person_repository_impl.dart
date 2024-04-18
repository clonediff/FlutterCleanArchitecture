import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/exception.dart';
import 'package:flutter_clean_architecture/core/error/failure.dart';
import 'package:flutter_clean_architecture/core/platform/network_info.dart';
import 'package:flutter_clean_architecture/feature/data/datasources/person_local_data_source.dart';
import 'package:flutter_clean_architecture/feature/data/datasources/person_remote_data_source.dart';
import 'package:flutter_clean_architecture/feature/data/models/person_model.dart';
import 'package:flutter_clean_architecture/feature/domain/entities/person_entity.dart';
import 'package:flutter_clean_architecture/feature/domain/repositories/person_repository.dart';

class PersonRepositoryImpl implements PersonRepository {
  final PersonRemoteDataSource remoteDataSource;
  final PersonLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PersonRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PersonEntity>>> getAllPersons(int page) => _getPersons(() => remoteDataSource.getAllPersons(page));

  @override
  Future<Either<Failure, List<PersonEntity>>> searchPerson(String query) => _getPersons(() => remoteDataSource.searchPerson(query));

  Future<Either<Failure, List<PersonEntity>>> _getPersons(Future<List<PersonModel>> Function() getPersons) async {
    try {
      List<PersonModel> persons;
      if (await networkInfo.isConnected) {
        persons = await getPersons();
        localDataSource.personsToCache(persons);
      } else {
        persons = await localDataSource.getLastPersonsFromCache();
      }
      return Right(persons);
    } on ServerException {
      return Left(ServerFailure());
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
