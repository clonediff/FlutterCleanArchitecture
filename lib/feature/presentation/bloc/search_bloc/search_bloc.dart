import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/error/failure.dart';
import 'package:flutter_clean_architecture/feature/domain/usecases/search_person.dart';
import 'package:flutter_clean_architecture/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:flutter_clean_architecture/feature/presentation/bloc/search_bloc/search_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchPerson _searchPersons;

  PersonSearchBloc({required SearchPerson searchPersons})
      : _searchPersons = searchPersons,
        super(PersonEmpty()) {
    on<SearchPersons>(_mapFetchPersonsToState);
  }

  FutureOr<void> _mapFetchPersonsToState(
      SearchPersons event, Emitter<PersonSearchState> emit) async {
    emit(PersonSearchLoading(oldPerson: event.oldPersons));

    final failureOrPerson = await _searchPersons(
        SearchPersonParams(query: event.personQuery, page: event.page));

    emit(
      failureOrPerson.fold(
        (failure) => PersonSearchError(message: _mapFailureToMessage(failure)),
        (persons) => PersonSearchLoaded(
            persons: [...event.oldPersons, ...persons], page: event.page),
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure) {
      case ServerFailure serverFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure cacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
