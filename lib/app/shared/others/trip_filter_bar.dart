import 'package:camer_trip/app/services/trip_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TripFilterBar extends ConsumerWidget {
  const TripFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final currentFilter = ref.watch(tripFilterProvider);

    final categories = [
      {'label': 'Toutes', 'cat': FilterCategory.none},
      {'label': 'Agences', 'cat': FilterCategory.agence},
      {'label': 'Départs', 'cat': FilterCategory.depart},
      {'label': 'Destinations', 'cat': FilterCategory.destination},
      {'label': 'Horaires', 'cat': FilterCategory.heure},
    ];

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: categories.map((item) {
              final cat = item['cat'] as FilterCategory;
              final isSelected = currentFilter.category == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(item['label'] as String),
                  selected: isSelected,
                  onSelected: (val) {
                    if (cat == FilterCategory.none) {
                      ref.read(tripFilterProvider.notifier).state = TripFilter();
                    } else {
                      _showValuePicker(context, ref, cat);
                    }
                  },
                  backgroundColor: Colors.transparent,
                  selectedColor: cs.primary,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : cs.onSurface.withOpacity(0.6),
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  side: BorderSide(color: isSelected ? cs.primary : cs.primary.withOpacity(0.1)),
                ),
              );
            }).toList(),
          ),
        ),
        
        // Affichage du filtre actif
        if (currentFilter.category != FilterCategory.none && currentFilter.value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              children: [
                Text(
                  'Filtre actif: ',
                  style: TextStyle(color: cs.onSurface.withOpacity(0.5), fontSize: 12),
                ),
                Chip(
                  label: Text('${currentFilter.value}'),
                  onDeleted: () => ref.read(tripFilterProvider.notifier).state = TripFilter(),
                  deleteIconColor: cs.primary,
                  backgroundColor: cs.primary.withOpacity(0.05),
                  side: BorderSide.none,
                  labelStyle: TextStyle(color: cs.primary, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _showValuePicker(BuildContext context, WidgetRef ref, FilterCategory cat) {
    final cs = Theme.of(context).colorScheme;
    
    List<String> values = [];
    String title = "";

    switch (cat) {
      case FilterCategory.agence:
        values = ["General Express", "Finexs Voyages", "Touristique Express"];
        title = "Choisir une Agence";
        break;
      case FilterCategory.depart:
        values = ["Douala", "Yaoundé", "Bafoussam"];
        title = "Ville de Départ";
        break;
      case FilterCategory.destination:
        values = ["Douala", "Yaoundé", "Bafoussam", "Limbé", "Garoua"];
        title = "Ville de Destination";
        break;
      case FilterCategory.heure:
        values = ["Matin", "Après-midi", "Soir"];
        title = "Tranche Horaire";
        break;
      default:
        return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: values.map((v) {
                  return ActionChip(
                    label: Text(v),
                    onPressed: () {
                      ref.read(tripFilterProvider.notifier).state = TripFilter(category: cat, value: v);
                      Navigator.pop(context);
                    },
                    backgroundColor: cs.surfaceContainerHigh,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
