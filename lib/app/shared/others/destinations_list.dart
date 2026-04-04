import 'package:camer_trip/app/config/const_config.dart';
import 'package:camer_trip/app/models/destination_model.dart';
import 'package:camer_trip/app/shared/cards/destination_card.dart';
import 'package:flutter/material.dart';

class DestinationsList extends StatelessWidget {
  final List<Destination> destinations;
  const DestinationsList({super.key, required this.destinations});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;
    return SizedBox(
      height: 170, // Légère augmentation pour éviter les débordements
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.largePadding,
        ),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(), // Force la réactivité du défilement
        itemCount: destinations.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) {
          return DestinationCard(
            dest: destinations[i],
            isDark: isDark,
            cs: cs,
          );
        },
      ),
    );
  }
}
