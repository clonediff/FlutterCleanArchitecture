import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/feature/domain/entities/person_entity.dart';
import 'package:flutter_clean_architecture/feature/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:flutter_clean_architecture/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:flutter_clean_architecture/feature/presentation/bloc/search_bloc/search_state.dart';
import 'package:flutter_clean_architecture/feature/presentation/widgets/search_result.dart';

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate() : super(searchFieldLabel: 'Search for characters...');

  void setupController(ScrollController scrollController, BuildContext context,
      PersonSearchLoaded personSearchLoaded, String query) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels != 0) {
        context.read<PersonSearchBloc>().add(SearchPersons(
              oldPersons: personSearchLoaded.persons,
              page: personSearchLoaded.page + 1,
              personQuery: query,
            ));
      }
    });
  }

  final List<String> _suggestions = [
    'Rick',
    'Morty',
    'Summer',
    'Beth',
    'Jerry',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
          icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back_outlined),
      tooltip: 'Back',
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    print('Inside custom search delegate and search query is $query');
    BlocProvider.of<PersonSearchBloc>(context, listen: false)
        .add(SearchPersons(personQuery: query, page: 1, oldPersons: const []));
    return BlocBuilder<PersonSearchBloc, PersonSearchState>(
      builder: (context, state) {
        List<PersonEntity> persons = [];
        bool isLoading = false;
        ScrollController scrollController = ScrollController();
        switch (state) {
          case PersonSearchLoading personSearchLoading
              when personSearchLoading.oldPerson.isEmpty:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case PersonSearchLoading personSearchLoading:
            persons = personSearchLoading.oldPerson;
            isLoading = true;
            break;
          case PersonSearchLoaded personSearchLoaded:
            persons = personSearchLoaded.persons;
            setupController(scrollController, context, personSearchLoaded, query);
            break;
          case PersonSearchError personSearchError:
            return _showErrorText(personSearchError.message);
          default:
            return const Center(
              child: Icon(Icons.now_wallpaper),
            );
        }

        return Container(
          child: persons.isEmpty
              ? _showErrorText('No Characters with that name found')
              : ListView.builder(
                  itemBuilder: (context, index) {
                    if (index == persons.length) {
                      Timer(const Duration(milliseconds: 30), () {
                        scrollController
                            .jumpTo(scrollController.position.maxScrollExtent);
                      });
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return SearchResult(
                      personResult: persons[index],
                    );
                  },
                  itemCount: persons.length + (isLoading ? 1 : 0),
                  controller: scrollController,
                ),
        );
      },
    );
  }

  Widget _showErrorText(String errorMessage) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(
          errorMessage,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) return Container();
    return ListView.separated(
      padding: EdgeInsets.all(10),
      itemBuilder: (context, index) => Text(
        _suggestions[index],
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: _suggestions.length,
    );
  }
}
