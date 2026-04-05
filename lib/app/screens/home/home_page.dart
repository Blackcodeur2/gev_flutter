import 'package:camer_trip/app/config/colors_config.dart';
import 'package:camer_trip/app/config/const_config.dart';
import 'package:camer_trip/app/models/ag_model.dart';
import 'package:camer_trip/app/models/destination_model.dart';
import 'package:camer_trip/app/models/promo_trip_model.dart';
import 'package:camer_trip/app/shared/cards/voyage_card.dart';
import 'package:camer_trip/app/shared/others/app_bar.dart';
import 'package:camer_trip/app/shared/others/categorie_bloc.dart';
import 'package:camer_trip/app/shared/others/destinations_list.dart';
import 'package:camer_trip/app/shared/others/list_agence.dart';
import 'package:camer_trip/app/shared/others/promo_carousel.dart';
import 'package:camer_trip/app/shared/others/search_bar.dart';
import 'package:camer_trip/app/shared/others/section_title.dart';
import 'package:camer_trip/app/shared/others/scheduled_trips_list.dart';
import 'package:camer_trip/app/shared/others/trip_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  final List<PromoTrip> _promos = const [
    PromoTrip(
      title: 'Douala → Yaoundé',
      subtitle: 'Dès 2 500 FCFA · 3h de trajet',
      badge: '🔥 Populaire',
      colors: [Color.fromARGB(255, 159, 97, 32), Color.fromARGB(255, 148, 108, 37)],
    ),
    PromoTrip(
      title: 'Yaoundé → Bafoussam',
      subtitle: 'Dès 3 000 FCFA · 4h de trajet',
      badge: '⚡ Rapide',
      colors: [Color(0xFF2E3192), Color(0xFF4C51BF)],
    ),
  ];

  final List<Destination> _destinations = const [
    Destination(name: 'Yaoundé', from: 'Douala', price: '2 500', duration: '3h', emoji: '🏙️'),
    Destination(name: 'Bafoussam', from: 'Yaoundé', price: '3 000', duration: '4h', emoji: '🏔️'),
  ];

  final List<Agence> _agences = const [
    Agence(name: 'General Express', route: 'Douala ↔ Yaoundé', rating: '4.8', color: AppColors.primaryGreen, icon: Icons.directions_bus_rounded),
    Agence(name: 'Finexs Voyages', route: 'Nord-Sud Cameroun', rating: '4.5', color: Color.fromARGB(255, 152, 109, 22), icon: Icons.directions_bus_filled_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: MyAppBar(isHome: true)),
              SliverToBoxAdapter(child: const MySearchBar()),
              SliverToBoxAdapter(child: _buildQuickFilters(cs)),
              SliverToBoxAdapter(child: PromoCarousel(promos: _promos)),

              // 📅 SECTION VOYAGES ET FILTRES
              SliverToBoxAdapter(
                child: SectionTitle(
                  title: '📅 Prochains Voyages',
                  action: 'Filtres',
                ),
              ),
              const SliverToBoxAdapter(child: TripFilterBar()),
              const ScheduledTripsList(),

              SliverToBoxAdapter(
                child: SectionTitle(
                  title: '🏢 Agences partenaires',
                  action: 'Voir tout',
                ),
              ),
              SliverToBoxAdapter(child: ListAgenceComponent(agences: _agences)),

              SliverToBoxAdapter(
                child: SectionTitle(
                  title: '📍 Destinations populaires',
                  action: 'Voir tout',
                ),
              ),
              SliverToBoxAdapter(
                child: DestinationsList(destinations: _destinations),
              ),

              SliverToBoxAdapter(
                child: SectionTitle(title: '🚌 Types de trajet', action: ''),
              ),
              SliverToBoxAdapter(child: buildCategories(context, cs)),

              SliverToBoxAdapter(
                child: SectionTitle(title: '🎟️ Réservation en cours', action: 'Détails'),
              ),
              const SliverToBoxAdapter(child: VoyageCard()),

              const SliverToBoxAdapter(child: SizedBox(height: 120)), 
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickFilters(ColorScheme cs) {
    final filters = ["Tous", "💸 Moins cher", "✨ VIP", "🌃 De nuit", "⚡ Direct"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: filters.map((label) {
          final isFirst = label == "Tous";
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(label),
              selected: isFirst,
              onSelected: (val) {},
              backgroundColor: Colors.transparent,
              selectedColor: cs.primary,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isFirst ? Colors.white : cs.onSurface.withOpacity(0.6),
                fontSize: 13,
                fontWeight: isFirst ? FontWeight.bold : FontWeight.normal,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide(
                color: isFirst ? cs.primary : cs.primary.withOpacity(0.15),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
