import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/feature/domain/entities/person_entity.dart';
import 'package:flutter_clean_architecture/feature/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'package:flutter_clean_architecture/feature/presentation/bloc/person_list_cubit/person_list_state.dart';
import 'package:flutter_clean_architecture/feature/presentation/widgets/person_card_widget.dart';

class PersonsList extends StatelessWidget {
  final ScrollController scrollController = ScrollController();

  void setupScrollController(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          // BlocProvider.of<PersonListCubit>(context).loadPerson();
          context.read<PersonListCubit>().loadPerson();
        }
      }
    });
  }

  PersonsList({super.key});

  @override
  Widget build(BuildContext context) {
    setupScrollController(context);

    return BlocBuilder<PersonListCubit, PersonState>(
      builder: (context, state) {
        bool isLoading = false;
        List<PersonEntity> persons = [];

        switch (state) {
          case PersonLoading personLoading when personLoading.isFirstFetch:
            return _loadingIndicator();
          case PersonLoading personLoading:
            persons = personLoading.oldPersonsList;
            isLoading = true;
          case PersonLoaded personLoaded:
            persons = personLoaded.personsList;
            break;
          case PersonError personError:
            return Text(
              personError.message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            );
        }

        return ListView.separated(
          itemBuilder: (context, index) {
            if (index == persons.length) {
              Timer(const Duration(milliseconds: 30), () {
                scrollController
                    .jumpTo(scrollController.position.maxScrollExtent);
              });
              return _loadingIndicator();
            } else {
              return PersonCard(person: persons[index]);
            }
          },
          separatorBuilder: (context, index) =>
              Divider(color: Colors.grey.shade400),
          itemCount: persons.length + (isLoading ? 1 : 0),
          controller: scrollController,
        );
      },
    );
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
