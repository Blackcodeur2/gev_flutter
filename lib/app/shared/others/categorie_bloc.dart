import 'package:camer_trip/app/config/const_config.dart';
import 'package:camer_trip/app/screens/home/categorie.dart';
import 'package:flutter/material.dart';

  Widget buildCategories(BuildContext context, ColorScheme cs) {
    final categories = [
      {'icon': Icons.directions_bus_rounded, 'label': 'Bus'},
      {'icon': Icons.airline_seat_recline_extra_rounded, 'label': 'VIP'},
      {'icon': Icons.more_horiz_rounded, 'label': 'Plus'},
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.largePadding,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) {
          final cat = categories[i];
          return CategoryItem(
            icon: cat['icon'] as IconData,
            label: cat['label'] as String,
            cs: cs,
          );
        },
      ),
    );
  }
