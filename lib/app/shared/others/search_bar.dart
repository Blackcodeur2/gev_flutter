import 'package:camer_trip/app/config/colors_config.dart';
import 'package:camer_trip/app/config/const_config.dart';
import 'package:camer_trip/app/shared/others/trip_search_delegate.dart';
import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: InkWell(
        onTap: () {
          showSearch(context: context, delegate: TripSearchDelegate());
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: isDark ? cs.surfaceContainerHigh : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: cs.primary.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            ],
            border: Border.all(
              color: cs.primary.withOpacity(isDark ? 0.1 : 0.05),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: cs.primary, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Où voulez-vous aller ?',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: cs.onSurface.withOpacity(0.5),
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.tune_rounded,
                  color: cs.primary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}