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
import 'package:camer_trip/app/shared/others/section_title.dart';
import 'package:camer_trip/app/shared/others/scheduled_trips_list.dart';
import 'package:camer_trip/app/shared/others/trip_filter_bar.dart';
import 'package:camer_trip/app/shared/others/kwc_reminder_banner.dart';
import 'package:camer_trip/app/services/providers.dart';
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
    
    // Synchronisation du statut utilisateur dès l'ouverture
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(syncUserProvider);
    });
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
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: cs.surface,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await ref.refresh(syncUserProvider.future);
            },
            displacement: 20,
            color: cs.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(child: MyAppBar(isHome: true)),
                
                // 🛡️ Bannière KWC si en attente
                userAsync.when(
                  data: (user) => user?.statut == "en attente" 
                      ? const SliverToBoxAdapter(child: KwcReminderBanner())
                      : const SliverToBoxAdapter(child: SizedBox.shrink()),
                  loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
                  error: (e, s) => const SliverToBoxAdapter(child: SizedBox.shrink()),
                ),
  
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
      ),
    );
  }
}