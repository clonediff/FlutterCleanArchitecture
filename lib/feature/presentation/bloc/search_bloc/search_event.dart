import 'package:equatable/equatable.dart';
import 'package:flutter_clean_architecture/feature/domain/entities/person_entity.dart';

abstract class PersonSearchEvent extends Equatable {
  const PersonSearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchPersons extends PersonSearchEvent {
  final String personQuery;
  final List<PersonEntity> oldPersons;
  final int page;

  const SearchPersons({
    required this.personQuery,
    required this.oldPersons,
    required this.page,
  });
}
