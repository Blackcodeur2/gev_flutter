import 'package:camer_trip/app/config/colors_config.dart';
import 'package:camer_trip/app/config/const_config.dart';
import 'package:camer_trip/app/config/theme_provider.dart';
import 'package:camer_trip/app/models/ag_model.dart';
import 'package:camer_trip/app/models/destination_model.dart';
import 'package:camer_trip/app/models/promo_trip_model.dart';
import 'package:camer_trip/app/screens/home/list_agence.dart';
import 'package:camer_trip/app/shared/cards/destination_card.dart';
import 'package:camer_trip/app/shared/cards/promo_card.dart';
import 'package:camer_trip/app/shared/cards/voyage_card.dart';
import 'package:camer_trip/app/shared/others/app_bar.dart';
import 'package:camer_trip/app/shared/others/categorie_bloc.dart';
import 'package:camer_trip/app/shared/others/destinations_list.dart';
import 'package:camer_trip/app/shared/others/list_agence.dart';
import 'package:camer_trip/app/shared/others/promo_carousel.dart';
import 'package:camer_trip/app/shared/others/search_bar.dart';
import 'package:camer_trip/app/shared/others/section_title.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
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
      title: 'Douala → Yaoundé',
      subtitle: 'Dès 2 500 FCFA · 3h de trajet',
      badge: '🔥 Populaire',
      colors: [Color.fromARGB(255, 44, 38, 130), Color.fromARGB(255, 30, 93, 124)],
    ),
    PromoTrip(
      title: 'Douala → Yaoundé',
      subtitle: 'Dès 2 500 FCFA · 3h de trajet',
      badge: '🔥 Populaire',
      colors: [Color.fromARGB(255, 125, 14, 124), Color.fromARGB(255, 197, 82, 207)],
    ),
    PromoTrip(
      title: 'Yaoundé → Bafoussam',
      subtitle: 'Dès 3 000 FCFA · 4h de trajet',
      badge: '⚡ Rapide',
      colors: [Color(0xFF2E3192), Color(0xFF4C51BF)],
    ),
    PromoTrip(
      title: 'Douala → Limbé',
      subtitle: 'Dès 1 500 FCFA · 1h30 de trajet',
      badge: '🌊 Détente',
      colors: [Color(0xFF319795), Color(0xFF4FD1C5)],
    ),
  ];

  final List<Destination> _destinations = const [
    Destination(
      name: 'Yaoundé',
      from: 'Douala',
      price: '2 500',
      duration: '3h',
      emoji: '🏙️',
    ),
    Destination(
      name: 'Bafoussam',
      from: 'Yaoundé',
      price: '3 000',
      duration: '4h',
      emoji: '🏔️',
    ),
    Destination(
      name: 'Limbé',
      from: 'Douala',
      price: '1 500',
      duration: '1h30',
      emoji: '🌊',
    ),
    Destination(
      name: 'Garoua',
      from: 'Yaoundé',
      price: '8 000',
      duration: '8h',
      emoji: '🌅',
    ),
    Destination(
      name: 'Kribi',
      from: 'Douala',
      price: '2 000',
      duration: '2h',
      emoji: '🏖️',
    ),
  ];

  final List<Agence> _agences = const [
    Agence(
      name: 'General Express',
      route: 'Douala ↔ Yaoundé',
      rating: '4.8',
      color: AppColors.primaryGreen,
      icon: Icons.directions_bus_rounded,
    ),
    Agence(
      name: 'Touristique Express',
      route: 'Toutes destinations',
      rating: '4.6',
      color: Color.fromARGB(255, 52, 57, 207),
      icon: Icons.airport_shuttle_rounded,
    ),
    Agence(
      name: 'Finexs Voyages',
      route: 'Nord-Sud Cameroun',
      rating: '4.5',
      color: Color.fromARGB(255, 152, 109, 22),
      icon: Icons.directions_bus_filled_rounded,
    ),
    Agence(
      name: 'Vatican Express',
      route: 'Ouest Cameroun',
      rating: '4.4',
      color: AppColors.primaryRed,
      icon: Icons.directions_bus_rounded,
    ),
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
              SliverToBoxAdapter(child: MyAppBar()),
              SliverToBoxAdapter(child: MySearchBar()),
              SliverToBoxAdapter(child: PromoCarousel(promos: _promos)),
              SliverToBoxAdapter(
                child: SectionTitle(title: '🚌 Catégories', action: ''),
              ),
              SliverToBoxAdapter(child: buildCategories(context, cs)),
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
                child: SectionTitle(
                  title: '🏢 Agences partenaires',
                  action: 'Voir tout',
                ),
              ),
              SliverToBoxAdapter(child: ListAgenceComponent(agences: _agences)),
              SliverToBoxAdapter(
                child: SectionTitle(title: '🎟️ Prochain voyage', action: ''),
              ),
              SliverToBoxAdapter(child: VoyageCard()),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
