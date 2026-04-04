import 'package:flutter/material.dart';

class TripSearchDelegate extends SearchDelegate<String> {
  final List<String> cities = [
    'Douala',
    'Yaoundé',
    'Bafoussam',
    'Kribi',
    'Garoua',
    'Maroua',
    'Ngaoundéré',
    'Bamenda',
    'Buea',
    'Limbe',
    'Dschang',
    'Foumban',
    'Ebolowa',
    'Bertoua',
  ];

  final List<String> recentSearches = [
    'Douala',
    'Yaoundé',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = cities
        .where((city) => city.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildCityList(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? recentSearches
        : cities
            .where((city) => city.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return _buildCityList(suggestions);
  }

  Widget _buildCityList(List<String> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.location_on_outlined),
          title: Text(list[index]),
          onTap: () {
            query = list[index];
            showResults(context);
            // Ici, on pourrait naviguer vers une page de résultats de recherche réelle
            // ou fermer le delegate avec la valeur
            close(context, list[index]);
          },
        );
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: theme.colorScheme.surface,
        iconTheme: theme.iconTheme.copyWith(color: theme.colorScheme.onSurface),
      ),
    );
  }
}
