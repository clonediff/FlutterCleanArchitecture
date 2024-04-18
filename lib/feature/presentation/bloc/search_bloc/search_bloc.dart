import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/error/failure.dart';
import 'package:flutter_clean_architecture/feature/domain/usecases/search_person.dart';
import 'package:flutter_clean_architecture/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:flutter_clean_architecture/feature/presentation/bloc/search_bloc/search_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchPerson searchPersons;

  PersonSearchBloc({required this.searchPersons}) : super(PersonEmpty()) {
    on<SearchPersons>(_mapFetchPersonsToState);
  }

  FutureOr<void> _mapFetchPersonsToState(
      SearchPersons event, Emitter<PersonSearchState> emit) async {
    emit(PersonSearchLoading());

    final failureOrPerson =
        await searchPersons(SearchPersonParams(query: event.personQuery));

    emit(
      failureOrPerson.fold(
        (failure) => PersonSearchError(message: _mapFailureToMessage(failure)),
        (persons) => PersonSearchLoaded(persons: persons),
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch(failure) {
      case ServerFailure serverFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure cacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
