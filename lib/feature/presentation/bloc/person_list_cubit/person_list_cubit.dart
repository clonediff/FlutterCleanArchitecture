import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/error/failure.dart';
import 'package:flutter_clean_architecture/feature/domain/entities/person_entity.dart';
import 'package:flutter_clean_architecture/feature/domain/usecases/get_all_persons.dart';
import 'package:flutter_clean_architecture/feature/presentation/bloc/person_list_cubit/person_list_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class PersonListCubit extends Cubit<PersonState> {
  final GetAllPersons getAllPersons;

  PersonListCubit({required this.getAllPersons}) : super(PersonEmpty());

  int page = 1;

  void loadPerson() async {
    if (state is PersonLoading) return;
    final currentState = state;

    var oldPerson = <PersonEntity>[];
    if (currentState is PersonLoaded) {
      oldPerson = currentState.personsList;
    }

    emit(PersonLoading(oldPerson, isFirstFetch: page == 1));

    final failureOrPerson = await getAllPersons(PagePersonParams(page: page));
    emit(
      failureOrPerson.fold(
        (failure) => PersonError(
          message: _mapFailureToMessage(failure),
        ),
        (character) {
          page++;
          final persons = (state as PersonLoading).oldPersonsList;
          persons.addAll(character);
          return PersonLoaded(personsList: persons);
        },
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
