import 'package:camer_trip/app/services/trip_filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TripFilterBar extends ConsumerStatefulWidget {
  const TripFilterBar({super.key});

  @override
  ConsumerState<TripFilterBar> createState() => _TripFilterBarState();
}

class _TripFilterBarState extends ConsumerState<TripFilterBar> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final initialQuery = ref.read(tripFilterProvider);
    _searchController = TextEditingController(text: initialQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? cs.surfaceContainerHigh : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isDark ? Colors.white10 : cs.primary.withOpacity(0.08),
          ),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) {
            ref.read(tripFilterProvider.notifier).state = val;
            setState(() {});
          },
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: 'Rechercher une ville, agence, destination...',
            hintStyle: TextStyle(
              color: cs.onSurface.withOpacity(0.4),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: cs.primary.withOpacity(0.6),
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: cs.onSurface.withOpacity(0.4),
                    ),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(tripFilterProvider.notifier).state = "";
                      setState(() {});
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }
}
