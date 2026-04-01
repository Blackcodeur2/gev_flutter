import 'package:camer_trip/app/config/const_config.dart';
import 'package:camer_trip/app/models/ag_model.dart';
import 'package:camer_trip/app/screens/home/list_agence.dart';
import 'package:flutter/material.dart';

class ListAgenceComponent extends StatelessWidget {
  final List<Agence> agences;
  const ListAgenceComponent({super.key, required this.agences});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.largePadding,
      ),
      child: Column(
        children: agences.map((a) {
          return AgenceListItem(agence: a, isDark: isDark, cs: cs);
        }).toList(),
      ),
    );
  }
}
