import 'package:equatable/equatable.dart';
import 'package:flutter_clean_architecture/feature/domain/entities/person_entity.dart';

abstract class PersonSearchState extends Equatable{
  const PersonSearchState();

  @override
  List<Object?> get props => [];
}

class PersonEmpty extends PersonSearchState {}

class PersonSearchLoading extends PersonSearchState {
  final List<PersonEntity> oldPerson;

  const PersonSearchLoading({required this.oldPerson});

  @override
  List<Object?> get props => [oldPerson];
}

class PersonSearchLoaded extends PersonSearchState {
  final List<PersonEntity> persons;
  final int page;

  const PersonSearchLoaded({required this.persons, required this.page});

  @override
  List<Object?> get props => [persons];
}

class PersonSearchError extends PersonSearchState {
  final String message;

  const PersonSearchError({required this.message});

  @override
  List<Object?> get props => [message];
}
