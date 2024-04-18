import 'package:equatable/equatable.dart';
import 'package:flutter_clean_architecture/feature/domain/entities/person_entity.dart';

abstract class PersonState extends Equatable{
  const PersonState();

  @override
  List<Object?> get props => [];
}

class PersonEmpty extends PersonState {}

class PersonLoading extends PersonState {
  final List<PersonEntity> oldPersonsList;
  final bool isFirstFetch;

  const PersonLoading(this.oldPersonsList, {this.isFirstFetch = false});

  @override
  List<Object?> get props => [oldPersonsList];
}

class PersonLoaded extends PersonState {
  final List<PersonEntity> personsList;

  const PersonLoaded({required this.personsList});

  @override
  List<Object?> get props => [personsList];
}

class PersonError extends PersonState {
  final String message;

  const PersonError({required this.message});
}